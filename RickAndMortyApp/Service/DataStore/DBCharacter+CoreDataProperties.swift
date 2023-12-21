//
//  DBCharacter+CoreDataProperties.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 21.12.2023.
//
//

import Foundation
import CoreData
import UIKit


extension DBCharacter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBCharacter> {
        return NSFetchRequest<DBCharacter>(entityName: "DBCharacter")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var gender: String
    @NSManaged public var status: String
    @NSManaged public var species: String
    @NSManaged public var origin: String
    @NSManaged public var type: String
    @NSManaged public var location: String
    @NSManaged public var image: UIImage?

}

extension DBCharacter : Identifiable {

}
