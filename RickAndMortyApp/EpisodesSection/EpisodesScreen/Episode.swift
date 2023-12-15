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
    var characterName: String?
    var image: UIImage?
    var isFavourite: Bool
    
    private init(id: Int, 
                 name: String,
                 episode: String,
                 characterName: String? = nil,
                 image: UIImage? = nil,
                 isFavourite: Bool = false) {
        self.id = id
        self.name = name
        self.episode = episode
        self.characterName = characterName
        self.image = image
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

