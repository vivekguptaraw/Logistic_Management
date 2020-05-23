//
//  MappableProtocol.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

protocol MappableProtocol {
    
    associatedtype PersistenceType: Storable
    
    //MARK: - Method
    func mapToPersistenceObject() -> PersistenceType
    static func mapFromPersistenceObject(_ object: PersistenceType) -> Self
    
}
