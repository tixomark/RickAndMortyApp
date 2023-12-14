//
//  EpisodesCoordinator.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

protocol EpisodesCoordinatorInput {
    func showCharacterModule()
}

extension EpisodesCoordinator: ServiceObtainable {
    var neededServices: [Service] {
        [.builder]
    }
    
    func addServices(_ services: [Service : ServiceProtocol]) {
        builder = (services[.builder] as! ScreenBuilderProtocol)
    }
}

final class EpisodesCoordinator: ChildCoordinator {
    var parent: any ParentCoordinator
    var rootController: UINavigationController
    private var builder: ScreenBuilderProtocol?
    
    init(parent: any ParentCoordinator) {
        self.parent = parent
        rootController = EpisodesNC()
    }
    
    func start() {
        guard let episodes = builder?.buildScreen(.episodes) else {
            print("EpisodesCoordinator: can not start")
            return
        }
        rootController.viewControllers = [episodes]
    }
    
    deinit {
        print("deinit EpisodesCoordinator")
    }
    
}

extension EpisodesCoordinator: EpisodesCoordinatorInput {
    func showCharacterModule() {
        guard let characterVC = builder?.buildScreen(.characterDetail) else {
            print("EpisodesCoordinator: can not showCharacterModule")
            return
        }
        rootController.pushViewController(characterVC, animated: true)
    }
}
