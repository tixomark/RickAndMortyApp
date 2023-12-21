//
//  DBEpisode+CoreDataProperties.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 21.12.2023.
//
//

import Foundation
import CoreData


extension DBEpisode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBEpisode> {
        return NSFetchRequest<DBEpisode>(entityName: "DBEpisode")
    }

    @NSManaged public var episode: String
    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var isFavourite: Bool
    @NSManaged public var character: DBCharacter?

}

extension DBEpisode : Identifiable {

}
