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
        dataPasser = (services[.dataPasser] as! DataPasserProtocol)
    }
}

final class FavouritesCoordinator: ChildCoordinator {
    var rootController: UINavigationController!
    var parent: any ParentCoordinator
    private var builder: ScreenBuilderProtocol?
    private var dataPasser: DataPasserProtocol?
    
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
        
//        rootController.viewControllers =
        rootController.setViewControllers([favouritesVC], animated: true)
    }
    
    
}

extension FavouritesCoordinator: FavouritesCoordinatorInput {
    func showCharacterScreen() {
        
    }
}
