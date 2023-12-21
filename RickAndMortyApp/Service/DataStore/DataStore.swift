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
    
    func fetchEpisode(_ id: Int) -> Episode?
    func fetchEpisodes() -> [Episode]
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
    
    private var lock = NSLock()
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
        let dbEpisode = DBEpisode(from: episode, 
                                  toContext: context)
        context.insert(dbEpisode)
        saveContext()
    }
    
    func deleteEpisode(_ id: Int) {
        guard let episode = fetchDBEpisode(id)
        else { return }
        
        context.delete(episode)
        saveContext()
    }
    
    private func fetchDBEpisode(_ id: Int) -> DBEpisode? {
        let request = DBEpisode.fetchRequest()
        request.includesSubentities = true
        request.predicate = NSPredicate(format: "id LIKE %@", "\(id)")
        
        guard let episode = try? context.fetch(request).first
        else  { return nil }
        
        return episode
    }
    
    func fetchEpisode(_ id: Int) -> Episode? {
        let request = DBEpisode.fetchRequest()
        request.includesSubentities = true
        request.predicate = NSPredicate(format: "id LIKE %@", "\(id)")
        
        guard let episode = try? context.fetch(request).first
        else  { return nil }
            
        return Episode(from: episode)
    }
    
    func fetchEpisodes() -> [Episode] {
        let request = DBEpisode.fetchRequest()
        request.includesSubentities = true
        
        let episodes = try? context.fetch(request)
        
        let result = episodes?.compactMap { episode in
            Episode(from: episode)
        }
        
        return result ?? []
    }
}
