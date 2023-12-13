//
//  TabBarController.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.tintColor = .blue
    }
    
    
    deinit {
        print("deinit TabBarController")
    }
}
