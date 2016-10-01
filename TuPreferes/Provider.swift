//
//  QuestionManagerFactory.swift
//  TuPreferes
//
//  Created by Mathieu Vandeginste on 01/10/2016.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import Foundation
import RealmSwift

class Provider {
    
    private static var _questionCache: QuestionCache?
    private static var _questionManager: QuestionManager?
    
    static func getQuestionCache() -> QuestionCache {
        guard let qc = self._questionCache else {
            let realm = try! Realm()
            let realmCache = RealmCache(realm: realm)
            let qc = QuestionCache(persisterFinder: realmCache)
            
            self._questionCache = qc
            return qc
        }
        
        return qc
    }
    
    static func getQuestionManager() -> QuestionManager {
        guard let qm = self._questionManager else {
            let questionCache = self.getQuestionCache()
            let qm = QuestionManager(client: DefaultHTTPClient(), questionGetter: questionCache)
            
            self._questionManager = qm
            return qm
        }
        
        return qm
    }
    
}
