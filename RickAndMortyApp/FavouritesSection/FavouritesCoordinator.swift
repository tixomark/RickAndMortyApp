//
//  FavouritesCoordinator.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

protocol FavouritesCoordinatorInput: AnyObject, ShowCharacterScreenCoordinatorInput {
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
        
        let interactor = favouritesVC.interactor as! DataEmitter
        dataPasser?.addEntity(.emitter(interactor,
                                       id: "FavouritesInteractor"))
        
        favouritesVC.coordinator = self
        rootController.setViewControllers([favouritesVC], animated: true)
    }
}

extension FavouritesCoordinator: FavouritesCoordinatorInput {
    func showCharacterScreen() {
        guard let characterVC: CharacterVC = builder?.buildScreen(.characterDetail)
        else {
            print("EpisodesCoordinator: can not showCharacterModule")
            return
        }
        
        guard let emitter = dataPasser?.getEmitter("FavouritesInteractor") as? CharacterDataEmitter,
                let receiver = characterVC.interactor as? CharacterDataReceiver
        else { return }
        
        characterVC.coordinator = self
        passCharcter(from: emitter, to: receiver)
        rootController.pushViewController(characterVC, animated: true)
    }
}

extension FavouritesCoordinator {
    func passCharcter(from source: CharacterDataEmitter, to destination: CharacterDataReceiver) {
        let character = source.emitCharacter()
        destination.receive(character)
    }
}
