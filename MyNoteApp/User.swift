//
//  User.swift
//  MyNoteApp
//
//  Created by Myles Young on 12/1/19.
//  Copyright © 2019 Myles Young. All rights reserved.
//

import UIKit

protocol Identifiable {
    var id: String? { get set }
}

struct User: Codable, Identifiable {
    var id: String? = nil
    var name: String?
    var priority: Int
    var task: String?
    
    init(name: String, priority: Int, task: String) {
        self.name = name
        self.priority = priority
        self.task = task
    }
}

