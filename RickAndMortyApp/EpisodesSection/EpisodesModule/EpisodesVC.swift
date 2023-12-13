//
//  EpisodesVC.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 12.12.2023.
//

import Foundation
import UIKit

protocol EpisodesVCInput: AnyObject {
    
}

final class EpisodesVC: UIViewController {
    
    var interactor: EpisodesInteractorInput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        self.title = "apisodes"
    }
    
    deinit {
        print("deinit EpisodesVC")
    }
}

extension EpisodesVC: EpisodesVCInput {
    
}
