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
    func buildScreen(_ screen: Builder.EpisodesModuleScreen) -> UIViewController
}

final class Builder: ServiceProtocol, ServiceDistributor {
    var description: String { "ModuleBuilder service"}
    weak var serviceInjector: ServiceInjectorProtocol?
    
    enum EpisodesModuleScreen {
        case episodes, characterDetail
    }
    enum Coordinator {
        case main
        case episodes(parent: any ParentCoordinator)
        case favourites(parent: any ParentCoordinator)
    }
    
}

extension Builder: ScreenBuilderProtocol {
    func buildScreen(_ module: EpisodesModuleScreen) -> UIViewController {
        switch module {
        case .episodes:
            buildEpisodesScreen()
        case .characterDetail:
            buildCharacterScreen()
        }
    }
    
    private func buildEpisodesScreen() -> UIViewController {
        let view = EpisodesVC()
        let interactor = EpisodesInteractor()
        let presenter = EpisodesPresenter()
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        serviceInjector?.injectServicesFor(interactor)
        return view
    }
    private func buildCharacterScreen() -> UIViewController {
        let view = CharacterVC()
        let interactor = CharacterInteractor()
        let presenter = CharacterPresenter()
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        serviceInjector?.injectServicesFor(interactor)
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

