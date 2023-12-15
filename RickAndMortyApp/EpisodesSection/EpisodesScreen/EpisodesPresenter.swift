//
//  EpisodesPresenter.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation

protocol EpisodesPresenterInput {
    func presentFetchedEpisodes(_ episodes: EpisodesList.FetchEpisodes)
}

final class EpisodesPresenter {
    weak var view: EpisodesVCInput?
    
    deinit {
        print("deinit EpisodesPresenter")
    }
}

extension EpisodesPresenter: EpisodesPresenterInput {
    func presentFetchedEpisodes(_ episodes: EpisodesList.FetchEpisodes) {
        guard case let .response(netEpisodes, characters) = episodes else { return }
        var episodes = [Episode]()
        for (index, netEpisode) in netEpisodes.enumerated() {
            guard let episode = Episode(from: netEpisode)
            else { continue }
            
            let char = characters[index]
            episode.image = char.inage
            episode.characterName = char.name
            episodes.append(episode)
        }
        
        view?.displayFetchedEpisodes(.viewModel(episodes: episodes))
    }
    
    
}
