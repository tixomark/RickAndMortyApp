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

extension MainCoordinator: ServiceObtainable {
    var neededServices: [Service] {
        [.builder]
    }
    
    func addServices(_ services: [Service : ServiceProtocol]) {
        builder = (services[.builder] as! BuilderProtocol)
    }
}


final class MainCoordinator: ParentCoordinator {
    var childCoordinators: [any ChildCoordinator]
    var rootController: UITabBarController
    var builder: BuilderProtocol!
    
    init() {
        rootController = TabBarController()
        childCoordinators = []
    }
    
    func start() {
        let episodesCoordinator: EpisodesCoordinator = builder.build(.episodes(parent: self))
        childCoordinators.append(episodesCoordinator)
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

