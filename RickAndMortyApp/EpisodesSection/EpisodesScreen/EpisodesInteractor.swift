//
//  EpisodesInteractor.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

protocol EpisodesInteractorInput {
    func fetchEpisodes(_ request: EpisodesList.FetchEpisodes)
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
    private typealias CharacterData = (UIImage?, String)
    
    func fetchEpisodes(_ request: EpisodesList.FetchEpisodes) {
        Task(priority: .userInitiated) { () -> () in
            let result: Response<NetworkEpisode>? = await networkService?.getPage(pagePath: nil)
            guard let episodes = result?.results
            else { return }
            
            let characterData = await fetchRandomCharactersData(fromEpisodes: episodes)
            presenter?.presentFetchedEpisodes(.response(episodes: episodes, characters: characterData))
        }
    }
    
    private func fetchRandomCharactersData(fromEpisodes episodes: [NetworkEpisode]) async -> [CharacterData] {
        let characters = await withTaskGroup(of: (index: Int, character: CharacterData).self) { group -> [CharacterData] in
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
            
            var groupResult = Array<CharacterData>(repeating: (nil, ""), count: episodes.count)
            for await (index, chracter) in group {
                groupResult[index] = chracter
            }
            
            return groupResult
        }
        return characters
    }
    
    private func fetchCharacterData(from path: String) async -> CharacterData {
        let character = await self.networkService?.getCharacterBy(path: path)
        guard let imagePath = character?.image,
              let characterName = character?.name
        else {
            return (nil, character?.name ?? "")
        }
        
        let image = await self.networkService?.getImage(atPath: imagePath)
        return (image, characterName)
    }
}


