//
//  DBEpisode+CoreDataClass.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 20.12.2023.
//
//

import Foundation
import CoreData

@objc(DBEpisode)
public class DBEpisode: NSManagedObject {

    convenience init(from episode: Episode, toContext context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = Int64(episode.id)
        self.episode = episode.episode
        self.name = episode.name
        self.isFavourite = episode.isFavourite
        self.character = DBCharacter(from: episode.character, toContext: context)
    }
}
