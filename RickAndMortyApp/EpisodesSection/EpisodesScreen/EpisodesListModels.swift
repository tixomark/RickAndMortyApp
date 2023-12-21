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
typealias TapLikeButton = EpisodesList.TapLikeButton
typealias DeselectLikeButton = EpisodesList.DeselectLikeButton

enum EpisodesList {
    enum FetchEpisodes {
        struct Request {
            var nextPage: Bool = false
        }
        struct Response {
            var episodesFoundInStore: [Episode?]
            var episodes: [NetworkEpisode]
            var characters: [(image: UIImage?,
                              character: NetworkCharacter)?]
            var lastPage: Bool
            
        }
        struct ViewModel {
            var episodes: [Episode]
            var lastPage: Bool
        }
    }
    
    enum TapCharacter {
        struct Request {
            var character: Character
            var index: Int
        }
    }
    
    enum TapLikeButton {
        struct Request {
            var episode: Episode
            var state: LikeView.State
        }
    }
    
    enum DeselectLikeButton {
        struct Responce {
            var episodeID: Int
        }
        struct ViewModel {
            var episodeID: Int
        }
    }
    
    
}
