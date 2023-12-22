//
//  EpisodesInteractor.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

protocol EpisodesInteractorInput {
    func fetchEpisodes(_ request: FetchEpisodes.Request)
    func queryEpisodes(_ request: QueryEpisodes.Request)
    func didTapLike(_ request: TapLikeButton.Request)
    func didTapCharacter(_ request: TapCharacter.Request)
}

extension EpisodesInteractor: ServiceObtainable {
    var neededServices: [Service] {
        [.metwork, .dataStore]
    }
    
    func addServices(_ services: [Service : ServiceProtocol]) {
        networkService = (services[.metwork] as! NetworkServiceProtocol)
        dataStore = (services[.dataStore] as! DataStoreProtocol)
    }
}

protocol CharacterDataEmitter {
    func emitCharacter() -> Character
}

extension EpisodesInteractor: CharacterDataEmitter, DataEmitter {
    var id: String {
        "EpisodesInteractor"
    }
    
    func emitCharacter() -> Character {
        selectedCharacter
    }
}

final class EpisodesInteractor {
    var presenter: EpisodesPresenterInput?
    private var networkService: NetworkServiceProtocol?
    private var dataStore: DataStoreProtocol?
    
    private var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
//        cache.countLimit = 100
        return cache
    }()
    
    private var selectedItemIndex: Int!
    private var selectedCharacter: Character!
    private var nextPage: String?
    private var isLastPage: Bool = false
    
    private var searchTask: Task<Void, Never>?
    
    @objc private func episodeRemoved(_ notification: NSNotification) {
        if let episodeID = notification.userInfo?["episode"] as? Int {
            let responce = DeselectLikeButton.Responce(episodeID: episodeID)
            presenter?.presentDeselectLikeButton(responce)
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(episodeRemoved(_:)),
                                               name: .removedEpisodeFromFavouritesInFavourites,
                                               object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .removedEpisodeFromFavouritesInFavourites,
                                                  object: nil)
    }
    
    deinit {
        removeObservers()
        print("deinit EpisodesInteractor")
    }
}

extension EpisodesInteractor: EpisodesInteractorInput {
    func didTapLike(_ request: TapLikeButton.Request) {
        Task(priority: .userInitiated) {
            
            var episodeInfo: [String: Int] = [:]
            episodeInfo["episode"] = request.episode.id
            
            switch request.state {
            case .selected:
                dataStore?.save(episode: request.episode)
                NotificationCenter.default.post(name: .addedEpisodeToFavourites, 
                                                object: nil, 
                                                userInfo: episodeInfo)
            case .normal:
                dataStore?.deleteEpisode(request.episode.id)
                NotificationCenter.default.post(name: .removedEpisodeFromFavouritesInEpisodeList,
                                                object: nil,
                                                userInfo: episodeInfo)
            }
            
            addObservers()
        }
    }
    
    func didTapCharacter(_ request: TapCharacter.Request) {
        self.selectedCharacter = request.character
        self.selectedItemIndex = request.index
    }
    
    private typealias CharacterData = (image: UIImage?, character: NetworkCharacter)
    
    func fetchEpisodes(_ request: FetchEpisodes.Request) {
        Task(priority: .userInitiated) { () -> () in
            if request.nextPage == false {
                self.nextPage = nil
                self.isLastPage = false
            }
            guard !self.isLastPage else {
                return
            }
            
            let result: Response<NetworkEpisode>? = await networkService?.getPage(pagePath: self.nextPage)
            await handleResult(result, asQuery: false)
        }
    }
    
    func queryEpisodes(_ request: QueryEpisodes.Request) {
        searchTask?.cancel()
        searchTask = Task(priority: .userInitiated) {
            let result: Response<NetworkEpisode>? = await networkService?.getEpisodesPageByQuery(request.query,
                                                                                                 queryType: request.type)
            await handleResult(result, asQuery: true)
        }
    }
    
    private func handleResult(_ result: Response<NetworkEpisode>?, asQuery: Bool) async {
        guard var episodes = result?.results
        else { return }
        
        self.nextPage = result?.info?.next
        self.isLastPage = result?.info?.next == nil
        
        let episodesFromStore = searchInStore(for: &episodes)
        
        let characterData = await self.fetchRandomCharactersData(fromEpisodes: episodes)
        
        
        switch asQuery {
        case true:
            let responce = QueryEpisodes.Response(episodesFoundInStore: episodesFromStore,
                                                  episodes: episodes,
                                                  characters: characterData,
                                                  lastPage: self.isLastPage)
            presenter?.presentQueriedEpisodes(responce)
        case false:
            let responce = FetchEpisodes.Response(episodesFoundInStore: episodesFromStore,
                                                  episodes: episodes,
                                                  characters: characterData,
                                                  lastPage: self.isLastPage)
            presenter?.presentFetchedEpisodes(responce)
        }
    }
    
    
    private func searchInStore(for episodes: inout [NetworkEpisode]) -> [Episode?] {
        var foundInStore: [Episode?] = Array(repeating: nil, count: episodes.count)
        
        for index in (0..<episodes.count).reversed() {
            if let episode = dataStore?.fetchEpisode(episodes[index].id!) {
                
                foundInStore[index] = episode
                episodes.remove(at: index)
            }
        }
        
        return foundInStore
    }
    
    private func fetchRandomCharactersData(fromEpisodes episodes: [NetworkEpisode]) async -> [CharacterData?] {
        let characters = await withTaskGroup(of: (index: Int, character: CharacterData?).self) { group -> [CharacterData?] in
            
            for (index, episode) in episodes.enumerated() {
                guard let numberOfCharacters = episode.characters?.count,
                        numberOfCharacters != 0
                else { continue }
                
                group.addTask {
                    let randomChar = Int.random(in: 0..<numberOfCharacters)
                    let characterPath = episode.characters![randomChar]
                    
                    let characterData = await self.fetchCharacterData(from: characterPath)
                    
                    return (index, characterData)
                }
            }
            
            var groupResult = Array<CharacterData?>(repeating: nil, count: episodes.count)
            for await (index, chracter) in group {
                groupResult[index] = chracter
            }
            
            return groupResult
        }
        return characters
    }
    
    private func fetchCharacterData(from path: String) async -> CharacterData? {
        guard let character = await self.networkService?.getCharacterBy(path: path)
        else { return nil }
        
        let image = await getImageFor(character)
        
        return (image, character)
    }
    
    private func getImageFor(_ character: NetworkCharacter) async -> UIImage? {
        let id = "\(character.id!)" as NSString
        var image: UIImage?
        
        if let imageFromCache = imageCache.object(forKey: id) {
            image = imageFromCache
        } else if let imagePath = character.image {
            image = await self.networkService?.getImage(atPath: imagePath)
            
            if let image {
                imageCache.setObject(image, forKey: id)
            }
        }
        return image
    }
}


