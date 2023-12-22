//
//  UIColor.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 13.12.2023.
//

import Foundation
import UIKit

extension UIColor {
    
    static var RMborderColor: UIColor {
        UIColor(red: CGFloat(0xF2) / 255,
                green: CGFloat(0xF2) / 255,
                blue: CGFloat(0xF7) / 255,
                alpha: 1)
    }
    
    static var RMfilterTextColor: UIColor {
        UIColor(red: CGFloat(0x21) / 255,
                green: CGFloat(0x96) / 255,
                blue: CGFloat(0xF3) / 255,
                alpha: 1)
    }
    
    static var RMfilterBackgroundColor: UIColor {
        UIColor(red: CGFloat(0xE3) / 255,
                green: CGFloat(0xF2) / 255,
                blue: CGFloat(0xFD) / 255,
                alpha: 1)
    }
    
    
    static var RMbackgroundColor: UIColor {
        getColor("RMBackgroundColor")
    }
    static var RMsecondaryColor: UIColor {
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
