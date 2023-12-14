//
//  EpisodesInteractor.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

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


