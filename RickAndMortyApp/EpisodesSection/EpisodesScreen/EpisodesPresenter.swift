//
//  EpisodesPresenter.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation

protocol EpisodesPresenterInput {
    func presentFetchedEpisodes(_ responce: FetchEpisodes.Response)
}

final class EpisodesPresenter {
    weak var view: EpisodesVCInput?
    
    deinit {
        print("deinit EpisodesPresenter")
    }
}

extension EpisodesPresenter: EpisodesPresenterInput {
    func presentFetchedEpisodes(_ responce: FetchEpisodes.Response) {
        var episodes = [Episode]()
        
        for (index, netEpisode) in responce.episodes.enumerated() {
            guard let episode = Episode(from: netEpisode)
            else { continue }
            
            episodes.append(episode)
            
            guard let characterData = responce.characters[index]
            else { continue }
            
            let character = Character(from: characterData.character)
            character?.image = characterData.image
            episode.character = character
        }
        
        let viewModel = FetchEpisodes.ViewModel(episodes: episodes)
        view?.displayFetchedEpisodes(viewModel)
    }
    
    
}
