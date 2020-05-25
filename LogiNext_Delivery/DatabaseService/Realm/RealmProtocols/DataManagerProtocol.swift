//
//  DataManagerProtocol.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation
import RealmSwift

public protocol Storable {
 
}

protocol DataManagerProtocol {
    func create<T: Storable>(_ model: T.Type, value: [T], completion: @escaping ((T) -> Void)) throws
    func save(object: Storable) throws
    func update(object: Storable, completion: @escaping ((Bool) -> Void)) throws
    func delete(object: Storable) throws
    func deleteAll<T: Storable>(_ model: T.Type) throws
    func fetch<T: Storable>(_ model: T.Type, predicate: NSPredicate?, sorted: Sorted?, completion: (([T]) -> ()))
}

extension Object: Storable {
    
}
