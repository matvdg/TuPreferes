//
//  QuestionManagerTest.swift
//  TuPreferes
//
//  Created by Aurélien Baumann on 22/04/2016.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import XCTest
@testable import TuPreferes

class QuestionManagerTest: XCTestCase {
    
    var questionManager: QuestionManager? = nil
    
    override func setUp() {
        super.setUp()
        questionManager = QuestionManager(client: MockHttpClient())
    }
    
    override func tearDown() {
        super.tearDown()
        questionManager = nil
    }
    
    func testCreateNewQuestion() {
        /* Given */
        let dict = ["content": "What is your name?", "choices": [["content": "John Doe", "content_short": "John"], ["content": "Foo Bar", "content_short": "Foo"]]]
        
        /* When */
        let q = questionManager!.createNewQuestion(dict)
        
        /* Then */
        XCTAssertEqual(q.content, "What is your name?")
        XCTAssertEqual(q.choices.count, 2)
        XCTAssertEqual(q.choices[0].content, "John Doe")
        XCTAssertEqual(q.choices[0].contentShort, "John")
        XCTAssertEqual(q.choices[1].content, "Foo Bar")
        XCTAssertEqual(q.choices[1].contentShort, "Foo")
    }
}

class MockHttpClient: HttpClient {
    func get(url: NSURL, callback: (NSData?, NSError?)->() ) {}
}
