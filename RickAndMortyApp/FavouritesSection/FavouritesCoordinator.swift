//
//  FavouritesCoordinator.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

protocol FavouritesCoordinatorInput: AnyObject {
    func showCharacterScreen()
}

extension FavouritesCoordinator: ServiceObtainable {
    var neededServices: [Service] {
        [.builder, .dataPasser]
    }
    
    func addServices(_ services: [Service : ServiceProtocol]) {
        builder = (services[.builder] as! ScreenBuilderProtocol)
    }
}

final class FavouritesCoordinator: ChildCoordinator {
    var rootController: UINavigationController!
    var parent: any ParentCoordinator
    private var builder: ScreenBuilderProtocol?
    
    init(parent: some ParentCoordinator) {
        self.parent = parent
        rootController = FavouritesNC()
    }
    
    func start() {
        guard let favouritesVC: FavouritesVC = builder?.buildScreen(.favourites)
        else {
            print("EpisodesCoordinator: can not start")
            return
        }
        
        favouritesVC.coordinator = self
        rootController.viewControllers = [favouritesVC]
    }
    
    
}

extension FavouritesCoordinator: FavouritesCoordinatorInput {
    func showCharacterScreen() {
        
    }
}
