//
//  FavouritesPresenter.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 18.12.2023.
//

import Foundation

protocol FavouritesPresenterInput {
    func presentFavouriteEpisodes(_ responce: FetchFavouriteEpisodes.Response)
}

final class FavouritesPresenter {
    weak var view: FavouritesVCInput?
    
    deinit {
        print("deinit FavouritesPresenter")
    }
}

extension FavouritesPresenter: FavouritesPresenterInput {
    func presentFavouriteEpisodes(_ responce: FetchFavouriteEpisodes.Response) {
        
    }
    
    
}