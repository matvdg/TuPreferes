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
    
    var httpClient: MockHttpClient? = nil
    var questionManager: QuestionManager? = nil
    
    override func setUp() {
        super.setUp()
        httpClient = MockHttpClient()
        questionManager = QuestionManager(client: httpClient!)
    }
    
    override func tearDown() {
        super.tearDown()
        questionManager = nil
        httpClient = nil
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
    
    func testGetNextQuestion() {
        /* Given */
        let viewCtrl = MockViewController()
        
        /* When */
        questionManager?.getNextQuestion(viewCtrl)
        
        /* Then */
        XCTAssertEqual(httpClient?.lastCalledURL, NSURL(string: "http://api.tu-preferes.aubm.net/api/questions"))
        XCTAssertNotNil(viewCtrl.lastQuestion)
        XCTAssertEqual(viewCtrl.lastQuestion?.content, "Tu préfères vivre 20 ans millionaire ou toute une vie pauvre ?")
    }
    
    func testGetNextQuestionWithError() {
        /* Given */
        httpClient?.respondWithError = true
        let viewCtrl = MockViewController()
        
        /* When */
        questionManager?.getNextQuestion(viewCtrl)
        
        /* Then */
        XCTAssertEqual(httpClient?.lastCalledURL, NSURL(string: "http://api.tu-preferes.aubm.net/api/questions"))
        XCTAssertNil(viewCtrl.lastQuestion)
    }
    
}

class MockHttpClient: HttpClient {
    var lastCalledURL: NSURL? = nil
    var respondWithError: Bool = false
    let data: NSData = ("[{ \"id\": \"55f891f4ae3a9170bebd9e7d\", \"content\": \"Tu préfères vivre 20 ans millionaire ou toute une vie pauvre ?\", \"published\": true, \"created_at\": \"2015-09-15T23:47:32.903+02:00\", \"modified_at\": \"2015-09-15T23:51:27.043+02:00\", \"choices\": [ { \"content\": \"Vivre 20 ans\", \"content_short\": \"20 ans\", \"slug\": \"20-ans\" }, { \"content\": \"Toute une vie\", \"content_short\": \"Une vie\", \"slug\": \"une-vie\" } ], \"statistics\": { \"total_votes\": 3, \"men_votes\": 1, \"women_votes\": 2, \"per_choice\": { \"20-ans\": { \"total_votes\": 1, \"men_votes\": 0, \"women_votes\": 1 }, \"une-vie\": { \"total_votes\": 2, \"men_votes\": 1, \"women_votes\": 1 } } } }]" as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
    
    func get(url: NSURL, callback: (NSData?, NSError?)->() ) {
        lastCalledURL = url
        if respondWithError {
            callback(nil, NSError(domain: "some error" , code: 1, userInfo: nil))
            return
        }
        callback(data, nil)
    }
}

class MockViewController: QuestionManagerDelegate {
    var lastQuestion: Question? = nil
    func OnNextQuestion(question: Question?) {
        lastQuestion = question
    }
}