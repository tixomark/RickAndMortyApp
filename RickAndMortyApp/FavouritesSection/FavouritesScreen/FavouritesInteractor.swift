//
//  FavouritesInteractor.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 18.12.2023.
//

import Foundation
import UIKit

protocol FavouritesInteractorInput {
    func fetchFavouriteEpisodes(_ request: FetchFavouriteEpisodes.Request)
}

extension FavouritesInteractor: ServiceObtainable {
    var neededServices: [Service] {
        [.dataStore]
    }
    
    func addServices(_ services: [Service : ServiceProtocol]) {
        dataStore = (services[.dataStore] as! DataStoreProtocol)
    }
}

final class FavouritesInteractor {
    var presenter: FavouritesPresenterInput?
    private var dataStore: DataStoreProtocol?
    
    deinit {
        print("deinit FavouritesInteractor")
    }
}

extension FavouritesInteractor: FavouritesInteractorInput {
    func fetchFavouriteEpisodes(_ request: FetchFavouriteEpisodes.Request) {
        Task(priority: .userInitiated) {
            guard let episodes = dataStore?.fetchEpisodes()
            else { return }
            let responce = FetchFavouriteEpisodes.Response(episodes: episodes)
            presenter?.presentFavouriteEpisodes(responce)
        }
    }
    
    
}


