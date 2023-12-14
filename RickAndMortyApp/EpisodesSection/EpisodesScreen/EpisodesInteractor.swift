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

extension EpisodesInteractor: ServiceObtainable {
    var neededServices: [Service] {
        [.metwork]
    }
    
    func addServices(_ services: [Service : ServiceProtocol]) {
        networkService = (services[.metwork] as! NetworkServiceProtocol)
    }
    
    
}

final class EpisodesInteractor {
    var presenter: EpisodesPresenterInput?
    var networkService: NetworkServiceProtocol?
    
    deinit {
        print("deinit EpisodesInteractor")
    }
}

extension EpisodesInteractor: EpisodesInteractorInput {
    
}


