//
//  Question.swift
//  TuPréfères
//
//  Created by Mathieu Vandeginste on 21/04/2016.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import Foundation
import RealmSwift


class Question: Object {
    dynamic var content = ""
    dynamic var firstChoice: Choice?
    dynamic var lastChoice: Choice?
}

class Choice: Object {
    dynamic var content: String = ""
    dynamic var contentShort: String = ""
}