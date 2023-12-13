//
//  EpisodesInteractor.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation

protocol EpisodesInteractorInput {
    
}

final class EpisodesInteractor {
    var presenter: EpisodesPresenterInput?
    
    
    deinit {
        print("deinit EpisodesInteractor")
    }
}

extension EpisodesInteractor: EpisodesInteractorInput {
    
}
