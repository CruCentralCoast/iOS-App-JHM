//
//  DocumentCollection.swift
//  Cru
//
//  A DAO protocol for documents contained in the Cru database.
//
//  Created by Quan Tran on 2/9/16.
//  Copyright © 2016 Jamaican Hopscotch Mafia. All rights reserved.
//

import Foundation

struct TypeNames {
    static let Event = "event"
}

protocol DocumentCollection {
    typealias Type
    var collectionName : String { get }
}

extension DocumentCollection {
    func getAll() -> [Type] {
        var collection = [Type]()
        return collection
        //ServerUtils.loadResources(collectionName, Type.)
        
    }
    
    func insert(item : Type) -> Bool{
        return false
    }

    func delete(item : Type) -> Bool{
        return false
    }

    func update(old : Type, new : Type) -> Bool{
        return false
    }

    func search(query : String) -> [Type]{
        var result = [Type]()
        return result
    }

}