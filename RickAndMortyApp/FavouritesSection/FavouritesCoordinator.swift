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

final class FavouritesCoordinator: ChildCoordinator {
    var rootController: UINavigationController
    var parent: any ParentCoordinator
    
    init(parent: some ParentCoordinator) {
        self.parent = parent
        rootController = FavouritesNC()
    }
    
    func start() {
        
    }
    
    
}
