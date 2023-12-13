//
//  CharacterPresenter.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation

protocol CharacterPresenterInput {
    
}

final class CharacterPresenter {
    weak var view: CharacterVCInput?
    
    deinit {
        print("deinit CharacterPresenter")
    }
}

extension CharacterPresenter: CharacterPresenterInput {
    
}
