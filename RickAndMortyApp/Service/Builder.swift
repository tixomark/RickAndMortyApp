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
    func buildScreen<S: UIViewController>(_ module: Builder.Screen) -> S
}

protocol ContainerBuilderProtocol: AnyObject {
    func buildMainTabBar(_ viewControllers: [UIViewController]) -> TabBarController
}

final class Builder: ServiceProtocol, ServiceDistributor {
    var description: String { "ModuleBuilder service"}
    weak var serviceInjector: ServiceInjectorProtocol?
    
    enum Screen {
        case episodes
        case characterDetail
        case favourites
    }
    enum Coordinator {
        case main
        case episodes(parent: any ParentCoordinator)
        case favourites(parent: any ParentCoordinator)
    }
    
}

extension Builder: ContainerBuilderProtocol {
    func buildMainTabBar(_ viewControllers: [UIViewController]) -> TabBarController {
        let item0 = UITabBarItem(title: nil,
                                 image: .homeIconNormal.withRenderingMode(.alwaysOriginal),
                                 selectedImage: .homeIconSelected.withRenderingMode(.alwaysOriginal))
        let item1 = UITabBarItem(title: nil,
                                 image: .favouritesIconNormal.withRenderingMode(.alwaysOriginal),
                                 selectedImage: .favouritesIconSelected.withRenderingMode(.alwaysOriginal))
        
        let imageInset = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        item0.imageInsets = imageInset
        item1.imageInsets = imageInset
        
        viewControllers[0].tabBarItem = item0
        viewControllers[1].tabBarItem = item1

        let controller = TabBarController()
        
        controller.setViewControllers(viewControllers, animated: false)
        controller.selectedIndex = 0
        
        return controller
    }

    
    
}

extension Builder: ScreenBuilderProtocol {
    func buildScreen<S: UIViewController>(_ module: Screen) -> S {
        switch module {
        case .episodes:
            buildEpisodesScreen() as! S
        case .characterDetail:
            buildCharacterScreen() as! S
        case .favourites:
            buildFavouritesScreen() as! S
        }
    }
    
    private func buildEpisodesScreen() -> EpisodesVC {
        let view = EpisodesVC()
        let interactor = EpisodesInteractor()
        let presenter = EpisodesPresenter()
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        serviceInjector?.injectServicesFor(interactor)
        return view
    }
    private func buildCharacterScreen() -> CharacterVC {
        let view = CharacterVC()
        let interactor = CharacterInteractor()
        let presenter = CharacterPresenter()
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        serviceInjector?.injectServicesFor(interactor)
        return view
    }
    private func buildFavouritesScreen() -> FavouritesVC {
        let view = FavouritesVC()
        let interactor = FavouritesInteractor()
        let presenter = FavouritesPresenter()
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

