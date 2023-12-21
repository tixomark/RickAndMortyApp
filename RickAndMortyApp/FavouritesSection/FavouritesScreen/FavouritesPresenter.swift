//
//  FavouritesPresenter.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 18.12.2023.
//

import Foundation

protocol FavouritesPresenterInput {
    func fetchEpisodes(_ responce: FetchFavouriteEpisodes.Response)
    func deleteEpisode(_ responce: DeleteEpisode.Responce)
    func addEpisode(_ responce: AddEpisode.Responce)
}

final class FavouritesPresenter {
    weak var view: FavouritesVCInput?
    
    deinit {
        print("deinit FavouritesPresenter")
    }
}

extension FavouritesPresenter: FavouritesPresenterInput {
    func fetchEpisodes(_ responce: FetchFavouriteEpisodes.Response) {
        let viewModel = FetchFavouriteEpisodes.ViewModel(episodes: responce.episodes)
        view?.displayEpisodes(viewModel)
    }
    
    func deleteEpisode(_ responce: DeleteEpisode.Responce) {
        let viewModel = DeleteEpisode.ViewModel(id: responce.id)
        view?.deleteEpisode(viewModel)
    }

    func addEpisode(_ responce: AddEpisode.Responce) {
        let viewModel = AddEpisode.ViewModel(episode: responce.episode)
        view?.addEpisode(viewModel)
    }
    
    
}
