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
    let databaseRef = Database.database().reference()
    let colorSwapper = ColorSwapper()
    var isASC: Bool = true //everything shows asc by default
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // get shared reference from users array and refresh data
        FIRFirestoreService.shared.read(from: .users, returning: User.self) { (users) in
            self.users = users
            self.tableView.reloadData()
        }
    }

    // on add (+) button click
    @IBAction func onTaskTap(_ sender: Any) {
        AlertService.addUser(in: self) { user in
            FIRFirestoreService.shared.create(for: user, in: .users)
        }
    }
    
    // on click just toggle the order in which the page is displayed 🤷🏾‍♂️
    @IBAction func onSortButtonTap(_ sender: Any) {
        // sort Code toggle feature
        self.isASC.toggle()
        
        if (self.isASC == true) {
            print("ASC")
        } else {
            print("DESC")
        }
    }
    
    // on settings button tap
    @IBAction func onSettingsTap(_ sender: Any) {
        let alert = UIAlertController(title: "",
        message: "",
        preferredStyle: .alert)
        
        // Change font of the title and message
        let attributedTitle = NSMutableAttributedString(string: "Sort by category")
        let attributedMessage = NSMutableAttributedString(string: "Select an option")
        alert.setValue(attributedTitle, forKey: "attributedTitle")
        alert.setValue(attributedMessage, forKey: "attributedMessage")
        
        
        // sort Code, works 😏
        databaseRef.child("users").queryOrdered(byChild: "name").observe(.value, with: {
            snapshot in
            
            let action1 = UIAlertAction(title: "Name", style: .default, handler: { (action) -> Void in
                
                if(self.isASC == false) {
                    print("desc Name")
                    self.users.sort(by: {$1.name! < $0.name!})
                }  else if (self.isASC == true) {
                    print("asc Name")
                    self.users.sort(by: {$0.name! < $1.name!})
                }
                
                self.tableView.reloadData()
            })
            
            let action2 = UIAlertAction(title: "Priority", style: .default, handler: { (action) -> Void in
                
                if(self.isASC == false) {
                    print("desc Priority")
                    self.users.sort(by: {$1.priority < $0.priority})
                } else {
                    print("asc Priority")
                    self.users.sort(by: {$0.priority < $1.priority})
                }
                
                self.tableView.reloadData()
            })
            
            let action3 = UIAlertAction(title: "Task", style: .default, handler: { (action) -> Void in

                if(self.isASC == false) {
                    print("desc Task")
                    self.users.sort(by: {$1.task! < $0.task!})
                } else {
                    print("asc Task")
                    self.users.sort(by: {$0.task! < $1.task!})
                }
                
                self.tableView.reloadData()
            })
                
            // Cancel button
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })

            // Add action buttons and present the Alert
            alert.addAction(action1)
            alert.addAction(action2)
            alert.addAction(action3)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
        })
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // populate tableview
        return users.count
    }
    
    // display text labels as rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let user = users[indexPath.row]
        let randomColor = colorSwapper.addRandomColor()
        
        let task = user.task
        let priority = String(user.priority) //convert int to string
        
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = "Task: \(task ?? ""), Priority: \(priority)"
        cell.backgroundColor = randomColor
        
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
