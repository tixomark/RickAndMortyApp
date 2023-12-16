//
//  CharacterInteractor.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation

protocol CharacterInteractorInput {
    func getCharacter(_ request: GetCharacter.Request)
}

extension CharacterInteractor: ServiceObtainable {
    var neededServices: [Service] {
        []
    }
    
    func addServices(_ services: [Service : ServiceProtocol]) {
        
    }
    
    
}

final class CharacterInteractor {
    var presenter: CharacterPresenterInput?
    
    var character: Character!
    
    deinit {
        print("deinit CharacterInteractor")
    }
}

extension CharacterInteractor: CharacterInteractorInput {
    func getCharacter(_ request: GetCharacter.Request) {
        let responce = GetCharacter.Responce(character: character)
        presenter?.presentCharacter(responce)
    }
}

