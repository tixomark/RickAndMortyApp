//
//  CharacterInteractor.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation

protocol CharacterInteractorInput {
    
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
    
    
    deinit {
        print("deinit CharacterInteractor")
    }
}

extension CharacterInteractor: CharacterInteractorInput {
    
}

