//
//  DBCharacter+CoreDataClass.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 20.12.2023.
//
//

import Foundation
import CoreData

@objc(DBCharacter)
public class DBCharacter: NSManagedObject {

    convenience init?(from character: Character?, toContext context: NSManagedObjectContext) {
        guard let character
        else { return nil }
        
        self.init(context: context)
        
        self.id = Int64(character.id)
        self.name = character.name
        self.gender = character.gender
        self.status = character.status
        self.species = character.species
        self.origin = character.origin
        self.type = character.type
        self.location = character.location
        self.image = nil
    }
}
