//
//  Service.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 14.12.2023.
//

import Foundation

enum Service {
    case metwork, builder, dataPasser, dataStore
}

protocol ServiceProtocol: CustomStringConvertible {}

protocol ServiceObtainable {
    var neededServices: [Service] {get}
    func addServices(_ services: [Service: any ServiceProtocol])
}

protocol ServiceDistributor {
    var serviceInjector: ServiceInjectorProtocol? {get}
}
