//
//  Question.swift
//  TuPréfères
//
//  Created by Mathieu Vandeginste on 21/04/2016.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import Foundation



class Question {
    let content: String
    let choices: [Choice]
    
    init(content: String, choices: [Choice]){
        self.content = content
        self.choices = choices
    }
}

class Choice {
    let content: String
    let contentShort: String
    
    init(content: String, contentShort: String){
        self.content = content
        self.contentShort = contentShort
    }
}