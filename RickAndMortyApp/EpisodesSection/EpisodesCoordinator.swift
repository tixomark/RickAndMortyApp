//
//  EpisodesCoordinator.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

protocol EpisodesCoordinatorInput: AnyObject {
    func showCharacterScreen()
}

protocol EpisodesCoordinatorNavigationInput: AnyObject {
    func willNavigateToEpisodesScreen()
}

extension EpisodesCoordinator: ServiceObtainable {
    var neededServices: [Service] {
        [.builder, .dataPasser]
    }
    
    func addServices(_ services: [Service : ServiceProtocol]) {
        builder = (services[.builder] as! ScreenBuilderProtocol)
        dataPasser = (services[.dataPasser] as! DataPasserProtocol)
    }
}

final class EpisodesCoordinator: ChildCoordinator {
    var parent: any ParentCoordinator
    var rootController: UINavigationController!
    private var builder: ScreenBuilderProtocol?
    var dataPasser: DataPasserProtocol?
    
    init(parent: any ParentCoordinator) {
        self.parent = parent
        rootController = EpisodesNC()
    }
    
    func start() {
        (rootController as? EpisodesNC)?.coordinator = self
        
        guard let episodesVC: EpisodesVC = builder?.buildScreen(.episodes)
        else {
            print("EpisodesCoordinator: can not start")
            return
        }
        
        episodesVC.coordinator = self
        
        let interactor = episodesVC.interactor as! DataEmitter
        dataPasser?.addEntity(.emitter(interactor,
                                       id: "EpisodesInteractor"))
        
        rootController.viewControllers = [episodesVC]
    }
    
    deinit {
        print("deinit EpisodesCoordinator")
    }
}

extension EpisodesCoordinator: EpisodesCoordinatorInput {
    func showCharacterScreen() {
        guard let characterVC: CharacterVC = builder?.buildScreen(.characterDetail)
        else {
            print("EpisodesCoordinator: can not showCharacterModule")
            return
        }
        
        guard let emitter = dataPasser?.getEmitter("EpisodesInteractor") as? CharacterDataEmitter,
                let receiver = characterVC.interactor as? CharacterDataReceiver
        else { return }
        
        characterVC.coordinator = self
        passCharcter(from: emitter, to: receiver)
        rootController.pushViewController(characterVC, animated: true)
    }
}



extension EpisodesCoordinator {
    func passCharcter(from source: CharacterDataEmitter, to destination: CharacterDataReceiver) {
        let character = source.emitCharacter()
        destination.receive(character)
    }
}

extension EpisodesCoordinator: EpisodesCoordinatorNavigationInput {
    func willNavigateToEpisodesScreen() {
//        print("will show")
    }
    
    
}
