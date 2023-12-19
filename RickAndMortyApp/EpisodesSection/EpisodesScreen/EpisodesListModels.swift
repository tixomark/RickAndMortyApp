//
//  EpisodesModes.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 13.12.2023.
//

import Foundation
import UIKit

typealias FetchEpisodes = EpisodesList.FetchEpisodes
typealias TapCharacter = EpisodesList.TapCharacter

enum EpisodesList {
    enum FetchEpisodes {
        struct Request {}
        struct Response {
            var episodes: [NetworkEpisode]
            var characters: [(image: UIImage?,
                              character: NetworkCharacter)?]
            
        }
        struct ViewModel {
            var episodes: [Episode]
        }
    }
    
    enum TapCharacter {
        struct Request {
            var character: Character
            var index: Int
        }
    }
}
