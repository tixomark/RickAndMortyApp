//
//  UIImage.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 13.12.2023.
//

import Foundation
import UIKit

enum ImageName: String {
    case monitorIcon
    case cameraIcon
    
    case blackLogo
    case header
    case portalBackground
    case portalSpiral
}

extension UIImage {
    convenience init?(_ name: ImageName) {
        self.init(named: name.rawValue)
    }
}
