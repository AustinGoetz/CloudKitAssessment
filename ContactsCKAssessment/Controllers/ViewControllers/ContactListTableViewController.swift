//
//  ContactListTableViewController.swift
//  ContactsCKAssessment
//
//  Created by Austin Goetz on 10/18/19.
//  Copyright © 2019 Austin Goetz. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ContactController.shared.fetchAllContacts { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactController.shared.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)

        let contact = ContactController.shared.contacts[indexPath.row]
        cell.textLabel?.text = contact.name
        
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toContactDetailVC" {
            let destinationVC = segue.destination as? ContactDetailViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let contact = ContactController.shared.contacts[indexPath.row]
            destinationVC?.contact = contact
        }
    }
}
