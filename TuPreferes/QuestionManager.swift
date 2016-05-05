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
    
    let url = NSURL(string: "http://api.tu-preferes.aubm.net/api/questions?published=1")
    
    func createNewQuestion(data: NSDictionary) -> Question {
        let content = data["content"] as! String
        let question = Question()
        let choices = data["choices"] as! NSArray
        let firstChoice = Choice()
        let lastChoice = Choice()
        firstChoice.content = choices[0]["content"] as! String
        firstChoice.contentShort = choices[0]["content_short"] as! String
        lastChoice.content = choices[1]["content"] as! String
        lastChoice.contentShort = choices[1]["content_short"] as! String
        question.firstChoice = firstChoice
        question.lastChoice = lastChoice
        question.content = content
        return question
    }
    
    func readRemoteQuestions(delegate: QuestionReaderDelegate){
        self.client.get(self.url!) { (data, error) in
            guard let json = data else {
                print(error)
                return
            }
            do {
                let result = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                for element in result {
                    guard let data = element as? NSDictionary else {
                        continue
                    }
                    delegate.questionIsAvailable(self.createNewQuestion(data))
                }
            } catch {
                print("error deserializing")
            }
        }
    }
    
    func readNextQuestion(delegate: QuestionReaderDelegate) {
        delegate.questionIsAvailable(questionGetter.getQuestion())
    }
    
}


protocol QuestionReaderDelegate {
    func questionIsAvailable(question: Question?)
}

protocol QuestionGetter {
    func getQuestion() -> Question?
}