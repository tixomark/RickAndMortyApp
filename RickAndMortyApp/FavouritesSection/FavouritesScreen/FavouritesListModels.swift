//
//  FavouritesListModels.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 18.12.2023.
//

import Foundation
import UIKit

typealias FetchFavouriteEpisodes = FavouritesList.FetchFavouriteEpisodes

enum FavouritesList {
    enum FetchFavouriteEpisodes {
        struct Request {}
        struct Response {
            var episodes: [Episode]
        }
        struct ViewModel {
            var episodes: [Episode]
        }
    }
}
