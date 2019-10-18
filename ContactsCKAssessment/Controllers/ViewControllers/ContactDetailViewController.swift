//
//  ContactDetailViewController.swift
//  ContactsCKAssessment
//
//  Created by Austin Goetz on 10/18/19.
//  Copyright © 2019 Austin Goetz. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    // MARK: - Properties
    var contact: Contact? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helper Functions
    func updateViews() {
        guard let contact = contact else { return }
        nameTextField.text = contact.name
        phoneNumberTextField.text = contact.phoneNumber
        emailTextField.text = contact.email
    }
    
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text,
            !name.isEmpty else { return }
        ContactController.shared.createContact(name: name, phoneNumber: phoneNumberTextField?.text, email: emailTextField.text) { (success) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
