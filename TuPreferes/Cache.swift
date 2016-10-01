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
    
    func persist(_ realmObject: Object) {
        DispatchQueue.main.async{
            try! self.realm.write {
                self.realm.add(realmObject)
            }
        }
    }
    
    func find(_ type: Object.Type) -> Object? {
        return self.realm.objects(type).first
    }
}


protocol PersisterFinder {
    func persist(_ realmObject: Object)
    func find(_ type: Object.Type) -> Object?
}



