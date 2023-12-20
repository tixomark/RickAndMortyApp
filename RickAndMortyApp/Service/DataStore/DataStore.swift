//
//  Cacher.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 19.12.2023.
//

import Foundation
import CoreData
import UIKit


protocol DataStoreProtocol {
    func save(episode: Episode)
    func deleteEpisode(_ id: Int)
    
    func fetchEpisode(_ id: Int) -> DBEpisode? 
}

final class DataStore: ServiceProtocol {
    var description: String = "DataStore service"
    
    private lazy var persistentContainer: NSPersistentContainer = {
//        UIImageToDataTrasformer.register()
//        URLToStringTransformer.register()
        let container = NSPersistentContainer(name: "Episode")
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            } else {
                print(description.url ?? "")
            }
        }
        return container
    }()
    
    private var context: NSManagedObjectContext {
        self.persistentContainer.viewContext
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
}

extension DataStore: DataStoreProtocol {
    func save(episode: Episode) {
        let dbEpisode = DBEpisode(from: episode, toContext: context)
        context.insert(dbEpisode)
        print(episode, "\n saved")
        saveContext()
    }
    
    func deleteEpisode(_ id: Int) {
        guard let episode = fetchEpisode(id)
        else { return }
        context.delete(episode)
        
        print(episode, "\n deleted")
        saveContext()
    }
    
    func fetchEpisode(_ id: Int) -> DBEpisode? {
        let request = DBEpisode.fetchRequest()
        request.includesSubentities = true
        request.predicate = NSPredicate(format: "id LIKE %@", "\(id)")
        
        do {
            let episode = try? context.fetch(request).first
            return episode
        }
    }
}
