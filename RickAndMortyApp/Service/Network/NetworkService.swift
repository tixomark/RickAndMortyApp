//
//  NetworkService.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 14.12.2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func getCharacterBy(path: String) async -> Character?
    func getCharacterBy(id: Int) async -> Character?
    func getPage<T: Codable>(pagePath path: String?) async -> Response<T>?
}

final class NetworkService: ServiceProtocol {
    var description: String { "Network service" }
    
    enum BaseURLs: String {
        case characters = "https://rickandmortyapi.com/api/character"
        case locations = "https://rickandmortyapi.com/api/location"
        case episodes = "https://rickandmortyapi.com/api/episode"
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
    func getCharacterBy(path: String) async -> Character? {
        guard var url = URL(string: path) 
        else { return nil }
        let request = URLRequest(url: url)
        return await getUmSomething(using: request)
    }

    func getCharacterBy(id: Int) async -> Character? {
        guard var url = URL(string: BaseURLs.characters.rawValue) 
        else { return nil }
        url = url.appendingPathComponent(String(id))
        let request = URLRequest(url: url)
        return await getUmSomething(using: request)
    }

    func getPage<T: Codable>(pagePath path: String? = nil) async -> Response<T>? {
        let urlPath = 
        if path == nil {
            switch T.self {
            case is Episode.Type: BaseURLs.episodes.rawValue
            case is Character.Type: BaseURLs.characters.rawValue
            default: ""
            }
        } else {
            path
        }
        guard let urlPath,
                let url = URL(string: urlPath)
        else { return nil }
        let request = URLRequest(url: url)
        var something: Response<T>? = await getUmSomething(using: request)
        return something
    }
}
