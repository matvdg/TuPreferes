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
    
    var questionManager: QuestionManager?
    
    override func setUp() {
        super.setUp()
        questionManager = QuestionManager(client: httpClient!)
    }
    
    override func tearDown() {
        super.tearDown()
        questionManager = nil
        httpClient = nil
    }
    
    func testCreateNewQuestion() {
        /* Given */
        let dict = ["content": "What is your name?", "choices": [["content": "John Doe", "content_short": "John"], ["content": "Foo Bar", "content_short": "Foo"]]] as [String : Any]
        
        /* When */
        let q = questionManager!.createNewQuestion(dict)
        
        /* Then */
        XCTAssertEqual(q.content, "What is your name?")
        XCTAssertEqual(q.firstChoice!.content, "John Doe")
        XCTAssertEqual(q.firstChoice!.contentShort, "John")
        XCTAssertEqual(q.lastChoice!.content, "Foo Bar")
        XCTAssertEqual(q.lastChoice!.contentShort, "Foo")
    }
    
    func testReadNextQuestion() {
        /* Given */
        let viewCtrl = MockViewController()
        
        /* When */
        questionManager?.readNextQuestion(viewCtrl)
        
        /* Then */
        XCTAssertEqual(httpClient?.lastCalledURL, URL(string: "http://api.tu-preferes.aubm.net/api/questions?published=1"))
        XCTAssertNotNil(viewCtrl.lastQuestion)
        XCTAssertEqual(viewCtrl.lastQuestion?.content, "Tu préfères vivre 20 ans millionaire ou toute une vie pauvre ?")
    }
    
    func testReadNextQuestionWithError() {
        /* Given */
        httpClient?.respondWithError = true
        let viewCtrl = MockViewController()
        
        /* When */
        questionManager?.readNextQuestion(viewCtrl)
        
        /* Then */
        XCTAssertEqual(httpClient?.lastCalledURL, URL(string: "http://api.tu-preferes.aubm.net/api/questions?published=1"))
        XCTAssertNil(viewCtrl.lastQuestion)
    }
    
}


class MockViewController: QuestionReaderDelegate {
    var lastQuestion: Question? = nil
    func questionIsAvailable(_ question: Question?) {
        lastQuestion = question
    }
}
