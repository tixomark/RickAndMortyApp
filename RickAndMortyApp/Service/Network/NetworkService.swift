//
//  NetworkService.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 14.12.2023.
//

import Foundation
import UIKit

protocol NetworkServiceProtocol {
    func getCharacterBy(path: String) async -> NetworkCharacter?
    func getCharacterBy(id: Int) async -> NetworkCharacter?
    func getPage<T: Codable>(pagePath path: String?) async -> Response<T>?
    func getImage(atPath path: String) async -> UIImage?
    func getEpisodesPageByQuery<T: Codable>(_ query: String, queryType type: NetworkService.QueryType) async -> Response<T>?
}

final class NetworkService: ServiceProtocol {
    var description: String { "Network service" }
    
    private enum BaseURLs: String {
        case characters = "https://rickandmortyapi.com/api/character"
        case locations = "https://rickandmortyapi.com/api/location"
        case episodes = "https://rickandmortyapi.com/api/episode"
    }
    
    enum QueryType: String {
        case name
        case episode
    }
    
    private func getUmSomething<SomeType: Codable>(using request: URLRequest) async -> SomeType? {
        var result: SomeType?
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse,
                    response.statusCode / 100 == 2
            else {
                print("Bad response(status code is not 2xx)")
                return result
            }
            result = try JSONDecoder().decode(SomeType.self, from: data)
        } catch {
            print(error.localizedDescription)
        }
        return result
    }
    
}

extension NetworkService: NetworkServiceProtocol {
    func getCharacterBy(path: String) async -> NetworkCharacter? {
        guard let url = URL(string: path) 
        else { return nil }
        
        let request = URLRequest(url: url)
        
        return await getUmSomething(using: request)
    }

    func getCharacterBy(id: Int) async -> NetworkCharacter? {
        guard var url = URL(string: BaseURLs.characters.rawValue) 
        else { return nil }
        
        url = url.appendingPathComponent(String(id))
        let request = URLRequest(url: url)
        
        return await getUmSomething(using: request)
    }

    func getPage<T: Codable>(pagePath path: String?) async -> Response<T>? {
        let urlPath = 
        if path == nil {
            switch T.self {
            case is NetworkEpisode.Type: BaseURLs.episodes.rawValue
            case is NetworkCharacter.Type: BaseURLs.characters.rawValue
            default: ""
            }
        } else {
            path
        }
        
        guard let urlPath,
                let url = URL(string: urlPath)
        else { return nil }
        
        let request = URLRequest(url: url)
        
        return await getUmSomething(using: request)
    }
    
    func getImage(atPath path: String) async -> UIImage? {
        guard let url = URL(string: path)
        else {
            print("Bad url")
            return nil
        }
        let request = URLRequest(url: url)
        var result: UIImage?
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse,
                    response.statusCode / 100 == 2
            else {
                print("Bad response(status code is not 2xx)")
                return result
            }
            result = UIImage(data: data)
        } catch {
            print(error.localizedDescription)
        }
        return result
    }
    
    private func createEpisodesQueryPath(type: QueryType, query: String) -> String? {
        let baseQueryPath = BaseURLs.episodes.rawValue + "/"
        var urlComponents = URLComponents(string: baseQueryPath)!
        let queryItem = URLQueryItem(name: type.rawValue,
                                     value: query)
        urlComponents.queryItems = [queryItem]
        return urlComponents.url?.absoluteString
    }
    
    func getEpisodesPageByQuery<T: Codable>(_ query: String, queryType type: NetworkService.QueryType) async -> Response<T>? {
        let queryPath = createEpisodesQueryPath(type: type,
                                                query: query)
        return await getPage(pagePath: queryPath) as Response<T>?
    }
}
