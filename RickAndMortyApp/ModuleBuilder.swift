//
//  EpisodesBuilder.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

protocol ModuleBuilderProtocol: AnyObject {
    func buildModule(_ module: ModuleBuilder.EpisodesModule) -> UIViewController
}

final class ModuleBuilder {
    enum EpisodesModule {
        case episodes, characterDetail
    }
    
    private func buildEpisodesModule() -> UIViewController {
        let view = EpisodesVC()
        let interactor = EpisodesInteractor()
        let presenter = EpisodesPresenter()
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        return view
    }
    
    private func buildCharacterModule() -> UIViewController {
        let view = CharacterVC()
        let interactor = CharacterInteractor()
        let presenter = CharacterPresenter()
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        return view
    }
}

extension ModuleBuilder: ModuleBuilderProtocol {
    func buildModule(_ module: EpisodesModule) -> UIViewController {
        switch module {
        case .episodes:
            buildEpisodesModule()
        case .characterDetail:
            buildCharacterModule()
        }
    }
    
}


