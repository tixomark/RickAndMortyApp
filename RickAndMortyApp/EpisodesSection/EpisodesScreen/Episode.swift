//
//  Models.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 15.12.2023.
//

import Foundation
import UIKit

class Episode {
    var id: Int
    var name: String
    var episode: String
    var isFavourite: Bool
    var character: Character?
    
    private init(id: Int, 
                 name: String,
                 episode: String,
                 isFavourite: Bool = false) {
        self.id = id
        self.name = name
        self.episode = episode
        self.isFavourite = isFavourite
    }
    
    convenience init?(from episode: NetworkEpisode) {
        guard let id = episode.id,
                let name = episode.name,
                let episode = episode.episode
        else { return nil }
        
        self.init(id: id,
                  name: name,
                  episode: episode)
    }
}

