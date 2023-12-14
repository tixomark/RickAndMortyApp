//
//  UIColor.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 13.12.2023.
//

import Foundation
import UIKit

extension UIColor {
    static var RMBackgroundColor: UIColor {
        getColor("RMBackgroundColor")
    }
    static var RMSecondaryColor: UIColor {
        getColor("RMSecondaryColor")
    }
    
    fileprivate static func getColor(_ named: String) -> UIColor {
        guard let color = UIColor(named: named) else {
            print("No such color \(named) in assets")
            return UIColor.clear
        }
        return color
    }
}
