//
//  EpisodesPresenter.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

protocol EpisodesPresenterInput {
    func presentFetchedEpisodes(_ responce: FetchEpisodes.Response)
    func presentDeselectLikeButton(_ responce: DeselectLikeButton.Responce)
}

final class EpisodesPresenter {
    weak var view: EpisodesVCInput?
    
    deinit {
        print("deinit EpisodesPresenter")
    }
}

extension EpisodesPresenter: EpisodesPresenterInput {
    func presentDeselectLikeButton(_ responce: DeselectLikeButton.Responce) {
        let viewModel = DeselectLikeButton.ViewModel(episodeID: responce.episodeID)
        view?.displayDeselectLikeButton(viewModel)
    }
    
    func presentFetchedEpisodes(_ responce: FetchEpisodes.Response) {
        
        var episodesFromNet = createEpisodesByMerging(netEpisodes: responce.episodes,
                                                      characters: responce.characters)
        let episodesFromStore = responce.episodesFoundInStore
        
        let episodes = episodesFromStore.map { episode in
            if episode == nil {
                episodesFromNet.removeFirst()
            } else {
                episode!
            }
        }
        
        let viewModel = FetchEpisodes.ViewModel(episodes: episodes,
                                                lastPage: responce.lastPage)
        view?.displayFetchedEpisodes(viewModel)
    }
    
    private func createEpisodesByMerging(netEpisodes: [NetworkEpisode], 
                                         characters: [(image: UIImage?,
                                                       character: NetworkCharacter)?] 
    ) -> [Episode] {
        
        var episodesFromNet = [Episode]()
        
        for (index, netEpisode) in netEpisodes.enumerated() {
            guard let episode = Episode(from: netEpisode)
            else { continue }
            
            episodesFromNet.append(episode)
            
            guard let netCharacter = characters[index]
            else { continue }
            
            var character = Character(from: netCharacter.character)
            character?.image = netCharacter.image
            episodesFromNet[index].character = character
        }
        
        return episodesFromNet
    }
}
