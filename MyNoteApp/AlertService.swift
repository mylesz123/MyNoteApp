//
//  AlertService.swift
//  MyNoteApp
//
//  Created by Myles Young on 12/1/19.
//  Copyright © 2019 Myles Young. All rights reserved.
//

import UIKit

class AlertService {
    
    private init() {}
    
    static func addUser(in vc: UIViewController, completion: @escaping (User) -> Void) {
        let alert = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        alert.addTextField { (nameTF) in
            nameTF.placeholder = "Name"
        }
        alert.addTextField { (priorityTF) in
            priorityTF.placeholder = "Priority"
            priorityTF.keyboardType = .numberPad
        }
        alert.addTextField { (taskTF) in
            taskTF.placeholder = "task"
        }
        
        let add = UIAlertAction(title: "Add", style: .default) { _ in
            guard
                let name = alert.textFields?.first?.text,
                let priorityString = alert.textFields?[1].text,
                let task = alert.textFields?.last?.text,
                let priority = Int(priorityString)
                
                else { return }
            
            print(name)
            print(priority)
            print(task)
            
            let user = User(name: name, priority: priority , task: task)
            completion(user)
        }
        alert.addAction(add)
        vc.present(alert, animated: true)
    }
    
    static func update(_ user: User, in vc: UIViewController, completion: @escaping (User) -> Void) {
        let alert = UIAlertController(title: "Update \(user.name)", message: nil, preferredStyle: .alert)
        alert.addTextField { (nameTF) in
            nameTF.placeholder = "Name"
        }
        alert.addTextField { (priorityTF) in
            priorityTF.placeholder = "Priority"
            priorityTF.keyboardType = .numberPad
        }
        alert.addTextField { (taskTF) in
            taskTF.placeholder = "Task"
        }
        let update = UIAlertAction(title: "Update", style: .default) { _ in
            guard
                let name = alert.textFields?.first?.text,
                let priorityString = alert.textFields?[1].text,
                let task = alert.textFields?.last?.text,
                let priority = Int(priorityString)
                
                else { return }
            
            print(name)
            print(priority)
            print(task)
            
            var updatedUser = user
            updatedUser.priority = priority
            updatedUser.name = name
            updatedUser.task = task
            
            completion(updatedUser)
        }
        alert.addAction(update)
        vc.present(alert, animated: true)
    }
    
}
