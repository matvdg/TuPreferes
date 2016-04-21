//
//  QuestionManager.swift
//  TuPréfères
//
//  Created by Mathieu Vandeginste on 21/04/2016.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import Foundation

class QuestionManager {
    
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    let url = NSURL(string: "http://api.tu-preferes.aubm.net/api/questions")
    
    func createNewQuestion(data: NSDictionary) -> Question {
        let content = data["content"] as! String
        var choices = [Choice]()
        for choice in data["choices"] as! NSArray {
            choices.append(Choice(content: choice["content"] as! String, contentShort: choice["content"] as! String))
        }
        return Question(content: content, choices: choices)
    }
    
    func getNextQuestion(questionConsumer: QuestionConsumer) {
        self.client.get(self.url!, callback: { (data, error) in
            if let json = data {
                questionConsumer.OnNextQuestion(self.getQuestionFromJSON(json))
            } else {
                print(error)
                questionConsumer.OnNextQuestion(nil)
                return
            }
            
        })
    }
    
    private func getQuestionFromJSON(data: NSData) -> Question? {
        do {
            let result = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSArray
            guard let array = result else {
                return nil
            }
            guard let dico = array.firstObject as? NSDictionary else {
                return nil
            }
            return self.createNewQuestion(dico)
        } catch {
            return nil
        }

    
    
    }
    
    
    
}



protocol QuestionConsumer {
    func OnNextQuestion(question: Question?)
}