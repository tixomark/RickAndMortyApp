//
//  MainCoordinator.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

protocol MainCoordinatorInput {
    
}

extension MainCoordinator: ServiceObtainable {
    var neededServices: [Service] {
        [.builder]
    }
    
    func addServices(_ services: [Service : ServiceProtocol]) {
        builder = (services[.builder] as! (BuilderProtocol & ContainerBuilderProtocol))
    }
}


final class MainCoordinator: ParentCoordinator {
    var childCoordinators: [any ChildCoordinator]
    var rootController: UITabBarController!
    var builder: (BuilderProtocol & ContainerBuilderProtocol)!
    
    init() {
        childCoordinators = []
    }
    
    func start() {
        let episodesCoordinator: EpisodesCoordinator = builder.build(.episodes(parent: self))
        let favouritesCoordinator: FavouritesCoordinator = builder.build(.favourites(parent: self))
        childCoordinators.append(episodesCoordinator)
        childCoordinators.append(favouritesCoordinator)
        
        rootController = builder.buildMainTabBar([episodesCoordinator.rootController,
                                                  favouritesCoordinator.rootController])
        
        
        episodesCoordinator.start()
        favouritesCoordinator.start()
    }
    
    func childDidFinish(_ child: any ChildCoordinator) {
        
    }
    
    deinit {
        print("deinit EpisodesNC")
    }
    
}

extension MainCoordinator: MainCoordinatorInput {
    
}

