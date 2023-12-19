//
//  CharacterInteractor.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

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

protocol CharacterDataReceiver: DataReceiver {
    func receive(_ character: Character)
}
extension CharacterInteractor: CharacterDataReceiver {
    var id: String { "CharacterInteractor" }

    func receive(_ character: Character) {
        self.character = character
    }
}

final class CharacterInteractor {
    var presenter: CharacterPresenterInput?
    
    var character: Character?
    
    deinit {
        print("deinit CharacterInteractor")
    }
}

extension CharacterInteractor: CharacterInteractorInput {
    func getCharacter(_ request: GetCharacter.Request) {
        guard let character else { return }
        let responce = GetCharacter.Responce(character: character)
        presenter?.presentCharacter(responce)
    }
}

