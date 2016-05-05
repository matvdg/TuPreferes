//
//  CacheProtocol.swift
//  TuPreferes
//
//  Created by Mathieu Vandeginste on 05/05/2016.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import Foundation
import RealmSwift


class RealmCache: PersisterFinder {
    
    var realm: Realm
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func persist(realmObject: Object) {
        dispatch_async(dispatch_get_main_queue()){
            try! self.realm.write {
                self.realm.add(realmObject)
            }
        }
    }
    
    func find(type: Object.Type) -> Object? {
        return self.realm.objects(type).first
    }
}


protocol PersisterFinder {
    func persist(realmObject: Object)
    func find(type: Object.Type) -> Object?
}



