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
        []
    }
    
    func addServices(_ services: [Service : ServiceProtocol]) {
        
    }
    
    
}

final class FavouritesInteractor {
    var presenter: FavouritesPresenterInput?
    
    private var nextPage: String?
    
    deinit {
        print("deinit FavouritesInteractor")
    }
}

extension FavouritesInteractor: FavouritesInteractorInput {
    func fetchFavouriteEpisodes(_ request: FetchFavouriteEpisodes.Request) {
        
    }
    
    
}


