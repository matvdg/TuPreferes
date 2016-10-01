//
//  QuestionCache.swift
//  TuPreferes
//
//  Created by Mathieu Vandeginste on 05/05/2016.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import Foundation
import RealmSwift

class QuestionCache: QuestionReaderDelegate, QuestionGetter {
    
    var persisterFinder: PersisterFinder
    
    init(persisterFinder: PersisterFinder){
        self.persisterFinder = persisterFinder
    }
    
    func questionIsAvailable(_ question: Question?) {
        guard let q = question else { return }
        persisterFinder.persist(q)
    }
    
    func getQuestion() -> Question? {
        return self.persisterFinder.find(Question.self) as? Question
    }
    
}
