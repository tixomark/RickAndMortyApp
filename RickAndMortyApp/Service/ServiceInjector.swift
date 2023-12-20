//
//  Service+Protocol.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 14.12.2023.
//

import Foundation

protocol ServiceInjectorProtocol: AnyObject {
    func injectServicesFor(_ object: ServiceObtainable)
}

final class ServiceInjector {
    private var allServices: [Service: any ServiceProtocol] = [:]
    
    func getBuilder() -> Builder {
        allServices[.builder] as! Builder
    }
    
    init() {
        allServices[.metwork] = NetworkService()
        let bulder = Builder()
        bulder.serviceInjector = self
        allServices[.builder] = bulder
        allServices[.dataPasser] = DataPasser()
        allServices[.dataStore] = DataStore()
    }
}

extension ServiceInjector: ServiceInjectorProtocol {
    func injectServicesFor(_ object: ServiceObtainable) {
        var servicesForObject: [Service: any ServiceProtocol] = [:]
        object.neededServices.forEach { serviceName in
            let service = allServices[serviceName]
            servicesForObject[serviceName] = service
        }
        object.addServices(servicesForObject)
    }
}
