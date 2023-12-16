//
//  CharacterPresenter.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation

protocol CharacterPresenterInput {
    func presentCharacter(_ responce: GetCharacter.Responce)
}

final class CharacterPresenter {
    weak var view: CharacterVCInput?
    
    deinit {
        print("deinit CharacterPresenter")
    }
}

extension CharacterPresenter: CharacterPresenterInput {
    func presentCharacter(_ responce: GetCharacter.Responce) {
        let char = responce.character
        let infoFields: [String] = [char.gender,
                                    char.status,
                                    char.species,
                                    char.origin,
                                    char.type,
                                    char.location]
        
        let viewModel = GetCharacter.ViewModel(image: char.image,
                                               name: char.name,
                                               infoFields: infoFields)
        view?.displayCharacter(viewModel)
    }
}
