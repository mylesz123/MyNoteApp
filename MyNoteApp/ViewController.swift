//
//  FirstViewController.swift
//  MyNoteApp
//
//  Created by Myles Young on 11/30/19.
//  Copyright © 2019 Myles Young. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UITableViewController {
    
    // init array of users
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // get shared reference from users array and refresh data
        FIRFirestoreService.shared.read(from: .users, returning: User.self) { (users) in
            self.users = users
            self.tableView.reloadData()
        }
        
        // sort Code, can't convert priority (int) to string 
//        let databaseRef = Database.database().reference()
//
//        databaseRef.child("Name").queryOrderedByKey().observe(.childAdded, with: {
//            snapshot in
//
//            var snapshotValue = snapshot.value as? NSDictionary
//
//            let name = snapshotValue!["name"] as? String
//            snapshotValue = snapshot.value as? NSDictionary
//
//            let priority = snapshotValue!["priority"] as? String
//            snapshotValue = snapshot.value as? NSDictionary
//
//            let task = snapshotValue!["task"] as? String
//            snapshotValue = snapshot.value as? NSDictionary
//
//
//            self.users.insert(User(name: name ?? "", priority: priority, task: task ?? "") , at: 0)
//            self.users.sort(by: {$0.name! < $1.name!})
//            self.tableView.reloadData()
//        })
        
    }

    // on add (+) button click
    @IBAction func onTap(_ sender: Any) {
        AlertService.addUser(in: self) { user in
            FIRFirestoreService.shared.create(for: user, in: .users)
        }
    }
    
    
    @IBAction func onSettingsTap(_ sender: Any) {
        let alert = UIAlertController(title: "",
          message: "",
          preferredStyle: .alert)
        
        // Change font of the title and message
        let attributedTitle = NSMutableAttributedString(string: "Sort by category")
        let attributedMessage = NSMutableAttributedString(string: "Select an option")
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        let action1 = UIAlertAction(title: "Name", style: .default, handler: { (action) -> Void in
            print("Name selected!")
        })
        
        let action2 = UIAlertAction(title: "Priority", style: .default, handler: { (action) -> Void in
               print("Priority selected!")
        })
        
        let action3 = UIAlertAction(title: "Task", style: .default, handler: { (action) -> Void in
               print("Task selected!")
        })
            
           // Cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
           
        // Add action buttons and present the Alert
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // populate tableview
        return users.count
    }
    
    // display text labels as rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let user = users[indexPath.row]
        
        let task = user.task
        let priority = String(user.priority) //convert int to string
        
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = "\(task ?? "") : \(priority)"
        
        return cell
    }
    
    // show update alert service
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        
        AlertService.update(user, in: self) { updatedUser in
            FIRFirestoreService.shared.update(for: updatedUser, in: .users)
        }
    }
    
    // delete row from tableview and db
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //guard editingStyle == .delete else { return }
        
        let user = users[indexPath.row]
        FIRFirestoreService.shared.delete(user, in: .users)
        
    }
    
}
