//
//  DataModel.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 15.12.2023.
//

import Foundation

struct Response<T: Codable>: Codable {
    var info: Info?
    var results: [T]?
}

struct Info: Codable {
    var pages: Int?
    var next, prev: String?
}

struct NetworkEpisode: Codable {
    var id: Int?
    var name, airDate, episode: String?
    var characters: [String]?
    var url: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, episode, characters, url
        case airDate = "air_date"
    }
}
struct NetworkCharacter: Codable {
    var id: Int?
    var name, status, species, type, gender: String?
    var origin, location: String?
    var image: String?
    var episode: [String]?
    var url: String?
    
    enum LocationKeys: String, CodingKey {
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.status = try container.decode(String.self, forKey: .status)
        self.species = try container.decode(String.self, forKey: .species)
        self.type = try container.decode(String.self, forKey: .type)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.image = try container.decode(String.self, forKey: .image)
        self.episode = try container.decode([String].self, forKey: .episode)
        self.url = try container.decode(String.self, forKey: .url)
        
        let originContainer = try container.nestedContainer(keyedBy: LocationKeys.self, forKey: .origin)
        let locationContainer = try container.nestedContainer(keyedBy: LocationKeys.self, forKey: .location)
        
        self.origin = try originContainer.decode(String.self, forKey: .name)
        self.location = try locationContainer.decode(String.self, forKey: .name)
    }
}
