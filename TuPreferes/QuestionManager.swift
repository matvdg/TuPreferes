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
    
    let baseUrl = "https://tu-preferes-1330.appspot.com/api/questions"
    
    init(client: HttpClient, questionGetter: QuestionGetter) {
        self.client = client
        self.questionGetter = questionGetter
    }
    
    func createNewQuestion(_ data: [String: Any]) -> Question {
        let choices = data["choices"] as! NSArray
        
        let firstChoice = Choice()
        firstChoice.content = (choices[0] as! [String: String])["content"]!
        firstChoice.contentShort = (choices[0] as! [String: String])["content_short"]!
        firstChoice.slug = (choices[0] as! [String: String])["slug"]!
        
        let lastChoice = Choice()
        lastChoice.content = (choices[1] as! [String: String])["content"]!
        lastChoice.contentShort = (choices[1] as! [String: String])["content_short"]!
        lastChoice.slug = (choices[1] as! [String: String])["slug"]!
        
        let question = Question()
        question.firstChoice = firstChoice
        question.lastChoice = lastChoice
        
        question.id = data["id"] as! String
        question.content = data["content"] as! String
        
        return question
    }
    
    func createNewVote(q: Question, chosenTitle: String) -> Vote {
        let vote = Vote()
        
        switch chosenTitle {
        case q.firstChoice!.content:
            vote.choiceSlug = q.firstChoice!.slug
        case q.lastChoice!.content:
            vote.choiceSlug = q.lastChoice!.slug
        default:
            break
        }
        
        return vote
    }
    
    func submitVoteForQuestion(q: Question, v: Vote) {
        let url = URL(string: "\(self.baseUrl)/\(q.id)/votes")
        let data: [String: Any] = ["choice_slug": v.choiceSlug]
        self.client.postJson(url!, data: data) { (data, err) in
            print("hello Martin")
        }
    }
    
    func readRemoteQuestions(_ delegate: QuestionReaderDelegate){
        let url = URL(string: "\(self.baseUrl)?published=1")
        self.client.get(url!) { (data, error) in
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
