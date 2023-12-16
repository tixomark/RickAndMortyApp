//
//  EpisodesBuilder.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

protocol BuilderProtocol: AnyObject {
    func build<C: CoordinatorProtocol>(_ coordinator: Builder.Coordinator) -> C
}

protocol ScreenBuilderProtocol: AnyObject {
//    func buildScreen<S: UIViewController>(_ module: Builder.EpisodesModuleScreen) -> S
    func buildEpisodesScreen() -> EpisodesVC
    func buildCharacterScreen(_ character: Character) -> CharacterVC
}

final class Builder: ServiceProtocol, ServiceDistributor {
    var description: String { "ModuleBuilder service"}
    weak var serviceInjector: ServiceInjectorProtocol?
    
    enum EpisodesModuleScreen {
        case episodes
        case characterDetail(_ character: Character)
    }
    enum Coordinator {
        case main
        case episodes(parent: any ParentCoordinator)
        case favourites(parent: any ParentCoordinator)
    }
    
}

extension Builder: ScreenBuilderProtocol {
    func buildEpisodesScreen() -> EpisodesVC {
        let view = EpisodesVC()
        let interactor = EpisodesInteractor()
        let presenter = EpisodesPresenter()
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        serviceInjector?.injectServicesFor(interactor)
        return view
    }
    func buildCharacterScreen(_ character: Character) -> CharacterVC {
        let view = CharacterVC()
        let interactor = CharacterInteractor()
        let presenter = CharacterPresenter()
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        serviceInjector?.injectServicesFor(interactor)
        interactor.character = character
        return view
    }
    
}

extension Builder: BuilderProtocol {
    func build<C: CoordinatorProtocol>(_ coordinator: Coordinator) -> C {
        var result: (any CoordinatorProtocol)!
        switch coordinator {
        case .main:
            result = buildMainCoordinator()
        case .episodes(let parent):
            result = buildEpisodesCoordinator(parent: parent)
        case .favourites(let parent):
            result = buildFavouritesCoordinator(parent: parent)
        }
        return result as! C
    }
    
    private func buildMainCoordinator() -> MainCoordinator {
        let coordinator = MainCoordinator()
        coordinator.builder = self
        return coordinator
    }
    private func buildEpisodesCoordinator(parent: any ParentCoordinator) -> EpisodesCoordinator {
        let coordinator = EpisodesCoordinator(parent: parent)
        serviceInjector?.injectServicesFor(coordinator)
        return coordinator
    }
    private func buildFavouritesCoordinator(parent: any ParentCoordinator) -> FavouritesCoordinator {
        let coordinator = FavouritesCoordinator(parent: parent)
        serviceInjector?.injectServicesFor(coordinator)
        return coordinator
    }
    
    
}

