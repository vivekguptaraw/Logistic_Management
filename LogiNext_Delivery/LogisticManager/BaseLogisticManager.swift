//
//  BaseLogisticManager.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation
import RealmSwift

class BaseLogisticManager<T> {
    
    var dbManager : DataManagerProtocol
    
    required init(dbManager : DataManagerProtocol) {
        self.dbManager = dbManager
    }
    
    func fetch<T>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?, completion: (([T]) -> ())) where T : Storable {
        dbManager.fetch(model, predicate: predicate, sorted: sorted, completion: completion)
    }
    
    func deleteAll<T>(_ model: T.Type) throws where T : Storable {
        try dbManager.deleteAll(model)
    }
    
    func delete(object: Storable) throws {
        try dbManager.delete(object: object)
    }
    
    func update(object: Storable, completion: @escaping ((Bool) -> Void)) throws {
        try dbManager.update(object: object, completion: completion)
    }
    func save(object: Storable) throws {
        try dbManager.save(object: object)
    }
    
    func create<T>(_ model: T.Type, value: [T], completion: @escaping ((T) -> Void)) throws where T : Object {
        try dbManager.create(model, value: value, completion: completion)
    }
}
