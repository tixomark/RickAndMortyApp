//
//  CharacterVC.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

protocol CharacterVCInput: AnyObject {
    
}

final class CharacterVC: UIViewController {
    
    var interactor: CharacterInteractorInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }
    
    deinit {
        print("deinit CharacterVC")
    }
}

extension CharacterVC: CharacterVCInput {
    
}
