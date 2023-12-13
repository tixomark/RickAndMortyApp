//
//  CoordinatorProtocol.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

protocol CoordinatorProtocol {
    associatedtype RootController: UIViewController
    var rootController: RootController {get}
    
    func start()
}

protocol ChildCoordinator: CoordinatorProtocol {
    var parent: any ParentCoordinator {get}
}

protocol ParentCoordinator: CoordinatorProtocol {
    var childCoordinators: [any ChildCoordinator] {get set}
    
    func childDidFinish(_ child: any ChildCoordinator)
}
