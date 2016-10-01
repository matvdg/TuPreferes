//
//  QuestionManager.swift
//  TuPréfères
//
//  Created by Mathieu Vandeginste on 21/04/2016.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import Foundation

class QuestionManager {
    
    let client: HttpClient
    let questionGetter: QuestionGetter
    
    init(client: HttpClient, questionGetter: QuestionGetter) {
        self.client = client
        self.questionGetter = questionGetter
    }
    
    let url = URL(string: "http://api.tu-preferes.aubm.net/api/questions?published=1")
    
    func createNewQuestion(_ data: [String: Any]) -> Question {
        let choices = data["choices"] as! NSArray
        
        let firstChoice = Choice()
        firstChoice.content = (choices[0] as! [String: String])["content"]!
        firstChoice.contentShort = (choices[0] as! [String: String])["content_short"]!
        
        let lastChoice = Choice()
        lastChoice.content = (choices[1] as! [String: String])["content"]!
        lastChoice.contentShort = (choices[1] as! [String: String])["content_short"]!
        
        let question = Question()
        question.firstChoice = firstChoice
        question.lastChoice = lastChoice
        question.content = data["content"] as! String
        
        return question
    }
    
    func readRemoteQuestions(_ delegate: QuestionReaderDelegate){
        self.client.get(self.url!) { (data, error) in
            guard let json = data else {
                print(error)
                return
            }
            do {
                let result = try JSONSerialization.jsonObject(with: json) as! NSArray
                for element in result {
                    guard let data = element as? [String: Any] else {
                        continue
                    }
                    delegate.questionIsAvailable(self.createNewQuestion(data))
                }
            } catch {
                print("error deserializing")
            }
        }
    }
    
    func readNextQuestion(_ delegate: QuestionReaderDelegate) {
        delegate.questionIsAvailable(questionGetter.getQuestion())
    }
    
}


protocol QuestionReaderDelegate {
    func questionIsAvailable(_ question: Question?)
}

protocol QuestionGetter {
    func getQuestion() -> Question?
}
