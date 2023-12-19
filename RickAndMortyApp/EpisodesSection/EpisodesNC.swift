//
//  EpisodesNC.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

final class EpisodesNC: UINavigationController {
    weak var coordinator: EpisodesCoordinatorNavigationInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
    }
    
}

extension EpisodesNC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is EpisodesVC {
            coordinator?.willNavigateToEpisodesScreen()
        }
    }
}
