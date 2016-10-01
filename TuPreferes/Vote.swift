//
//  Vote.swift
//  TuPreferes
//
//  Created by Mathieu Vandeginste on 01/10/2016.
//  Copyright © 2016 Mathieu Vandeginste. All rights reserved.
//

import Foundation
import RealmSwift

class Vote: Object {
    dynamic var choiceSlug: String = ""
    dynamic var isAMan: Bool = false
}
