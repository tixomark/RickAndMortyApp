//
//  Character.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 15.12.2023.
//

import Foundation
import UIKit

struct Character {
    var id: Int
    var name, gender, status: String
    var species, origin, type, location: String
    var image: UIImage?
    
    init(id: Int,
         name: String,
         gender: String,
         status: String,
         species: String,
         origin: String,
         type: String,
         location: String,
         image: UIImage? = nil) {
        self.id = id
        self.name = name
        self.gender = gender
        self.status = status
        self.species = species
        self.origin = origin
        self.type = type
        self.location = location
        self.image = image
    }
    
    init?(from character: NetworkCharacter) {
        guard let id = character.id,
              let name = character.name,
                let gender = character.gender,
                let status = character.status,
                let species = character.species,
                let origin = character.origin,
                let type = character.type,
                let location = character.location
        else { return nil }
        
        self.init(id: id,
                  name: name,
                  gender: gender,
                  status: status,
                  species: species,
                  origin: origin,
                  type: type,
                  location: location)
    }
    
    init(from character: DBCharacter) {
        self.init(id: Int(character.id),
                  name: character.name,
                  gender: character.gender, 
                  status: character.status, 
                  species: character.species, 
                  origin: character.origin, 
                  type: character.type, 
                  location: character.location,
                  image: character.image)
    }
}
