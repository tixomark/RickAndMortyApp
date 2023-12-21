//
//  UIImageToStringTransformer.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 21.12.2023.
//

import Foundation
import UIKit

public final class UIImageToStringTrasformer: ValueTransformer {
    
    override public func transformedValue(_ value: Any?) -> Any? {
        guard let image = value as? UIImage,
              let imageData = image.pngData()
        else { return nil }
        
        let imageID = UUID().uuidString
        guard let imageURL = URL(string: imageID + ".png",
                                 relativeTo: FileManager.default.imagesDir)
        else { return nil }
        
        let imageIDCD = NSString(string: imageID)
        
        do {
            try imageData.write(to: imageURL)
            let data = try NSKeyedArchiver.archivedData(withRootObject: imageIDCD, requiringSecureCoding: true)
            return data
        } catch {
            print("Failed to transform `UIImage` to `String`")
            return nil
        }
    }
    
    override public func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data
        else { return nil }
        
        let imageID = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSString.self,
                                                from: data) as? String
        
        guard let imageID,
              let imageURL = URL(string: imageID + ".png",
                                 relativeTo: FileManager.default.imagesDir)
        else { return nil }
        
        do {
            let imageData = try Data(contentsOf: imageURL)
            let image = UIImage(data: imageData)
            return image
        } catch {
            print("Failed to transform `String` to `UIImage`")
            return nil
        }
    }
    
    override public class func allowsReverseTransformation() -> Bool {
        true
    }
}

extension UIImageToStringTrasformer {
    static let name = NSValueTransformerName(String(describing: UIImageToStringTrasformer.self))
    
    public static func register() {
        let transformer = UIImageToStringTrasformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}
