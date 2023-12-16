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
}

extension EpisodesInteractor: ServiceObtainable {
    var neededServices: [Service] {
        [.metwork]
    }
    
    func addServices(_ services: [Service : ServiceProtocol]) {
        networkService = (services[.metwork] as! NetworkServiceProtocol)
    }
    
    
}

final class EpisodesInteractor {
    var presenter: EpisodesPresenterInput?
    private var networkService: NetworkServiceProtocol?
    
    private var nextPage: String?
    
    deinit {
        print("deinit EpisodesInteractor")
    }
}

extension EpisodesInteractor: EpisodesInteractorInput {
    private typealias CharacterData = (image: UIImage?, character: NetworkCharacter)
    
    func fetchEpisodes(_ request: FetchEpisodes.Request) {
        Task(priority: .userInitiated) { () -> () in
            let result: Response<NetworkEpisode>? = await networkService?.getPage(pagePath: nil)
            guard let episodes = result?.results
            else { return }
            
            let characterData = await self.fetchRandomCharactersData(fromEpisodes: episodes)
            
            let responce = FetchEpisodes.Response(episodes: episodes,
                                                  characters: characterData)
            presenter?.presentFetchedEpisodes(responce)
        }
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
        
        guard let imagePath = character.image
        else {
            return (nil, character)
        }
        
        let image = await self.networkService?.getImage(atPath: imagePath)
        return (image, character)
    }
}


