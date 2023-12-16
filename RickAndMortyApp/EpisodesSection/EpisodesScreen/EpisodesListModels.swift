//
//  EpisodesModes.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 13.12.2023.
//

import Foundation
import UIKit

enum EpisodesList {
    enum FetchEpisodes {
        case request
        case response(episodes: [NetworkEpisode], 
                      characters: [(image: UIImage?, character: NetworkCharacter)?])
        case viewModel(episodes: [Episode])
    }
}
