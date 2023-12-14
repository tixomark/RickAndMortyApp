//
//  FavouritesCoordinator.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

protocol FavouritesCoordinatorInput {
    
}

extension FavouritesCoordinator: ServiceObtainable {
    var neededServices: [Service] {
        [.builder]
    }
    
    func addServices(_ services: [Service : ServiceProtocol]) {
        builder = (services[.builder] as! ScreenBuilderProtocol)
    }
}

final class FavouritesCoordinator: ChildCoordinator {
    var rootController: UINavigationController
    var parent: any ParentCoordinator
    private var builder: ScreenBuilderProtocol?
    
    init(parent: some ParentCoordinator) {
        self.parent = parent
        rootController = FavouritesNC()
    }
    
    func start() {
        
    }
    
    
}
