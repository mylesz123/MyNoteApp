//
//  FirstViewController.swift
//  MyNoteApp
//
//  Created by Myles Young on 11/30/19.
//  Copyright © 2019 Myles Young. All rights reserved.
//

import UIKit

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
    }

    // on add (+) button click
    @IBAction func onTap(_ sender: Any) {
        AlertService.addUser(in: self) { user in
            FIRFirestoreService.shared.create(for: user, in: .users)
        }
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
