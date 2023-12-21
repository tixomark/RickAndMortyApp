//
//  FavouritesListModels.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 18.12.2023.
//

import Foundation
import UIKit

typealias FetchFavouriteEpisodes = FavouritesList.FetchFavouriteEpisodes
typealias DeleteEpisode = FavouritesList.DeleteEpisode
typealias AddEpisode = FavouritesList.AddEpisode
typealias FavouritesTapCharacter = FavouritesList.TapCharacter

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
    
    enum DeleteEpisode {
        struct Request {
            var id: Int
        }
        struct Responce {
            var id: Int
        }
        struct ViewModel {
            var id: Int
        }
    }
    
    enum AddEpisode {
        struct Request {}
        struct Responce {
            var episode: Episode
        }
        struct ViewModel {
            var episode: Episode
        }
        
    }
    
    enum TapCharacter {
        struct Request {
            var character: Character
            var index: Int
        }
    }
}
