//
//  Document.Presentation.swift
//  Hippocampus
//
//  Created by Guido Kühn on 25.03.23.
//

import Foundation
import Smaug

class Presentation: DataStore<Presentation.Storage> {
   
    @Objects var queries: Set<Query>
    @Objects var groups: Set<Group>

    override func setup() -> Presentation {
//        let queries: [Query] = [.general, .notes, .topics]
//        queries.forEach {
//            add($0, timestamp: Date.distantPast)
//            $0.isStatic = true
//        }
        add(Group.builtIn, timestamp: Date.distantPast)
        return self
    }

//    override func storageKeyPath<T>(_: T.Type) -> ReferenceWritableKeyPath<PersistentGraph<String, String, Storage>, [PersistentGraph<String, String, Storage>.Item.ID : PersistentGraph<String, String, Storage>.Item]>? where T : PersistentGraph<String, String, Storage>.Item {
//        if let result = super.storageKeyPath(T.self) { return result }
//        
//        switch T.self {
//        case is Group.Type: return \Presentation.groupStorage
//        case is Query.Type: return \Presentation.queryStorage
//        default: return nil
//        }
//    }
}
