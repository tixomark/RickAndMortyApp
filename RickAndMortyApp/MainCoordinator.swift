//
//  MainCoordinator.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

protocol MainCoordinatorProtocol {
    
}


final class MainCoordinator: ParentCoordinator {
    var childCoordinators: [any ChildCoordinator]
    var rootController: UITabBarController
    
    init() {
        rootController = TabBarController()
        childCoordinators = []
        
    }
    
    func start() {
        let episodesCoordinator = EpisodesCoordinator(parent: self)
        rootController.viewControllers = [episodesCoordinator.rootController]
        episodesCoordinator.start()
    }
    
    func childDidFinish(_ child: any ChildCoordinator) {
        
    }
    
    
    deinit {
        print("deinit EpisodesNC")
    }
    
}

extension MainCoordinator: MainCoordinatorProtocol {
    
    
}
