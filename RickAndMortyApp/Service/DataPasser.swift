//
//  DataPassing.swift
//  RickAndMortyApp
//
//  Created by Tixon Markin on 18.12.2023.
//

import Foundation


protocol DataEmitter: AnyObject {
    var id: String {get}
}
protocol DataReceiver: AnyObject {
    var id: String {get}
}

protocol DataPasserProtocol {
    func addEntity(_ entities: DataPasser.Entity...)
    func getEmitter(_ id: String) -> DataEmitter?
    func getReceiver(_ id: String) -> DataReceiver?
}

final class DataPasser: ServiceProtocol, DataPasserProtocol {
    var description: String { "DataPasser service"}
    
    enum Entity {
        case emitter(_ emitter: any DataEmitter, id: String)
        case receiver(_ receiver: any DataReceiver, id: String)
    }
    
    private struct WeakEmitter {
        weak var item: (any DataEmitter)?
        init(item: any DataEmitter) {
            self.item = item
        }
    }
    private struct WeakReceiver {
        weak var item: (any DataReceiver)?
        init(item: any DataReceiver) {
            self.item = item
        }
    }
    
    private var emitters: [String: WeakEmitter] = [:]
    private var receivers: [String: WeakReceiver] = [:]
    
    func addEntity(_ entities: Entity...) {
        for entity in entities {
            switch entity {
            case let .emitter(emitter, id):
                emitters[id] = WeakEmitter(item: emitter)
            case let .receiver(receiver, id):
                receivers[id] = WeakReceiver(item: receiver)
            }
        }
    }
    
    func getEmitter(_ id: String) -> DataEmitter? {
        guard let emitter = emitters[id]?.item
        else { return nil }
        return emitter
    }
    
    func getReceiver(_ id: String) -> DataReceiver? {
        guard let receiver = receivers[id]?.item
        else { return nil }
        return receiver
    }
}



