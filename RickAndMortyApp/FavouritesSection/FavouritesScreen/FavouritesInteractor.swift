//
//  FavouritesInteractor.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 18.12.2023.
//

import Foundation
import UIKit

protocol FavouritesInteractorInput {
    func fetchFavouriteEpisodes(_ request: FetchFavouriteEpisodes.Request)
    func deleteEpisode(_ request: DeleteEpisode.Request)
    func didTapCharacter(_ request: FavouritesTapCharacter.Request)
}

extension FavouritesInteractor: ServiceObtainable {
    var neededServices: [Service] {
        [.dataStore]
    }
    
    func addServices(_ services: [Service : ServiceProtocol]) {
        dataStore = (services[.dataStore] as! DataStoreProtocol)
    }
}

//protocol CharacterDataEmitter {
//    func emitCharacter() -> Character
//}

extension FavouritesInteractor: CharacterDataEmitter, DataEmitter {
    var id: String {
        "EpisodesInteractor"
    }
    
    func emitCharacter() -> Character {
        selectedCharacter
    }
}


final class FavouritesInteractor {
    var presenter: FavouritesPresenterInput?
    private var dataStore: DataStoreProtocol?
    
    private var selectedItemIndex: Int!
    private var selectedCharacter: Character!
    
    @objc private func addEpisode(_ notification: NSNotification) {
        guard let episodeID = notification.userInfo?["episode"] as? Int,
              let episode = dataStore?.fetchEpisode(episodeID)
        else { return }
        
        let responce = AddEpisode.Responce(episode: episode)
        presenter?.addEpisode(responce)
        
    }
    
    @objc private func removeEpisode(_ notification: NSNotification) {
        if let episodeID = notification.userInfo?["episode"] as? Int {
            let responce = DeleteEpisode.Responce(id: episodeID)
            presenter?.deleteEpisode(responce)
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(addEpisode(_:)),
                                               name: .addedEpisodeToFavourites,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(removeEpisode(_:)),
                                               name: .removedEpisodeFromFavouritesInEpisodeList,
                                               object: nil)
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .addedEpisodeToFavourites,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .removedEpisodeFromFavouritesInEpisodeList,
                                                  object: nil)
    }
    
    deinit {
        removeObservers()
        print("deinit FavouritesInteractor")
    }
}

extension FavouritesInteractor: FavouritesInteractorInput {
    func fetchFavouriteEpisodes(_ request: FetchFavouriteEpisodes.Request) {
        Task(priority: .userInitiated) {
            guard let episodes = dataStore?.fetchEpisodes()
            else { return }
            
            let responce = FetchFavouriteEpisodes.Response(episodes: episodes)
            presenter?.fetchEpisodes(responce)
        }
        addObservers()
    }
    
    func deleteEpisode(_ request: DeleteEpisode.Request) {
        Task(priority: .userInitiated) {
            dataStore?.deleteEpisode(request.id)
            
            let responce = DeleteEpisode.Responce(id: request.id)
            presenter?.deleteEpisode(responce)
            
            var episodeInfo: [String: Int] = [:]
            episodeInfo["episode"] = request.id
            
            NotificationCenter.default.post(name: .removedEpisodeFromFavouritesInFavourites,
                                            object: nil,
                                            userInfo: episodeInfo)
        }
    }
    
    func didTapCharacter(_ request: FavouritesTapCharacter.Request) {
        self.selectedCharacter = request.character
        self.selectedItemIndex = request.index
    }
}

