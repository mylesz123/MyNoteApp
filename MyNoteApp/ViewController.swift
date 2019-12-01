//
//  FirstViewController.swift
//  MyNoteApp
//
//  Created by Myles Young on 11/30/19.
//  Copyright © 2019 Myles Young. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        FIRFirestoreService.shared.read(from: .users, returning: User.self) { (users) in
            self.users = users
            self.tableView.reloadData()
        }
    }

    @IBAction func onTap(_ sender: Any) {
        AlertService.addUser(in: self) { user in
            FIRFirestoreService.shared.create(for: user, in: .users)
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = String(user.priority)
        cell.detailTextLabel?.text = user.task
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        
        AlertService.update(user, in: self) { updatedUser in
            FIRFirestoreService.shared.update(for: updatedUser, in: .users)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let user = users[indexPath.row]
        FIRFirestoreService.shared.delete(user, in: .users)
        
    }
    
}
