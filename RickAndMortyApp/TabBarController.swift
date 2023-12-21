//
//  TabBarController.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .RMbackgroundColor
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowRadius = 2
        tabBar.layer.shadowOpacity = 0.17
        
        tabBar.itemPositioning = .centered
        
       
    }
    
    deinit {
        print("deinit TabBarController")
    }
}
