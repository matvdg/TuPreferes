//
//  QuestionCacheTest.swift
//  TuPreferes
//
//  Created by Mathieu Vandeginste on 05/05/2016.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import XCTest
import RealmSwift

@testable import TuPreferes

class QuestionCacheTest: XCTestCase {
    
    var mockCache: MockCache?
    var qc: QuestionCache?

    override func setUp() {
        super.setUp()
        mockCache = MockCache()
        qc = QuestionCache(persister: mockCache!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        mockCache = nil
        qc = nil
    }
    
    func testQuestionIsAvailable() {
        /* Given */
        let question = Question()
        
        /* When */
        qc?.questionIsAvailable(question)
        
        /* Then */
        XCTAssertEqual(question, mockCache!.lastPersistArg!)
    }
    
    func testQuestionIsAvailablewithNil() {
        
        /* When */
        qc?.questionIsAvailable(nil)
        
        /* Then */
        XCTAssertFalse(mockCache!.persistWasCalled)
    }

    
}

class MockCache: Persister {
    
    var lastPersistArg: Object?
    var persistWasCalled = false
    
    func persist(_ realmObject: Object){
        lastPersistArg = realmObject
        persistWasCalled = true
    }
    
}
