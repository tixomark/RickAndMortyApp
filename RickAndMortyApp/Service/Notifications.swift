//
//  Notifications.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 20.12.2023.
//

import Foundation

extension Notification.Name {
    static let addedEpisodeToFavourites = Notification.Name(rawValue: "addEpisodeToFavourites")
    static let removedEpisodeFromFavouritesInEpisodeList = Notification.Name(rawValue: "removedEpisodeFromFavouritesInEpisodeList")
    static let removedEpisodeFromFavouritesInFavourites = Notification.Name(rawValue: "removedEpisodeFromFavouritesInFavourites")
    
}
