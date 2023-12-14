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

final class EpisodesCoordinator: ChildCoordinator {
    var parent: any ParentCoordinator
    var rootController: UINavigationController
    let moduleBuilder: ModuleBuilderProtocol
    
    init(parent: any ParentCoordinator) {
        self.parent = parent
        rootController = EpisodesNC()
        moduleBuilder = ModuleBuilder()
    }
    
    func start() {
        let episodes = moduleBuilder.buildModule(.episodes)
        rootController.viewControllers = [episodes]
    }
    
    deinit {
        print("deinit EpisodesCoordinator")
    }
    
}

extension EpisodesCoordinator: EpisodesCoordinatorInput {
    func showCharacterModule() {
        let characterVC = moduleBuilder.buildModule(.characterDetail)
        rootController.pushViewController(characterVC, animated: true)
    }
}
