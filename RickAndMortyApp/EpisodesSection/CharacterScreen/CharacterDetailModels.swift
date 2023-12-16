//
//  CharacterDetailModels.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 16.12.2023.
//

import Foundation
import UIKit

typealias GetCharacter = CharacterDetailModels.GetCharacter

enum CharacterDetailModels {
    
    enum GetCharacter {
        struct Request {}
        struct Responce {
            var character: Character
        }
        struct ViewModel {
            var image: UIImage?
            var name: String
            var infoFields: [String]
        }
        
    }
}
