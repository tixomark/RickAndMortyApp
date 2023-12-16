//
//  EpisodesCoordinator.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

protocol EpisodesCoordinatorInput: AnyObject {
    func showCharacterModule(_ character: Character)
}

protocol EpisodesDataPassing {
    
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
        guard let episodesVC = builder?.buildEpisodesScreen()
        else {
            print("EpisodesCoordinator: can not start")
            return
        }
        
        episodesVC.coordinator = self
        rootController.viewControllers = [episodesVC]
    }
    
    deinit {
        print("deinit EpisodesCoordinator")
    }
    
}

extension EpisodesCoordinator: EpisodesCoordinatorInput {
    func showCharacterModule(_ character: Character) {
        guard let characterVC = builder?.buildCharacterScreen(character)
        else {
            print("EpisodesCoordinator: can not showCharacterModule")
            return
        }
        
        characterVC.coordinator = self
        rootController.pushViewController(characterVC, animated: true)
    }
}
