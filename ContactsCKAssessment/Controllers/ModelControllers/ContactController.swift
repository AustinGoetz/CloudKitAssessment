//
//  ContactController.swift
//  ContactsCKAssessment
//
//  Created by Austin Goetz on 10/18/19.
//  Copyright © 2019 Austin Goetz. All rights reserved.
//

import Foundation
import CloudKit

class ContactController {
    
    // Singleton
    static let shared = ContactController()
    
    // SoT
    var contacts: [Contact] = []
    
    // Public DataBase
    let publicDB = CKContainer.default().publicCloudDatabase
    
    // MARK: - CRUD
    
    // Create
    func createContact(name: String, phoneNumber: Int?, email: String?, completion: @escaping (Bool) -> Void) {
        
        let newContact = Contact(name: name, phoneNumber: phoneNumber, email: email)
        let record = CKRecord(contact: newContact)
        
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            
            guard let record = record,
                let savedContact = Contact(ckRecord: record) else {
                    print("Error creating contact")
                    completion(false)
                    return
            }
            
            self.contacts.append(savedContact)
            print("Yay! We created a contact!")
            completion(true)
        }
    }
    
    // Read/Get
    func fetchAllContacts(completion: @escaping (Bool) -> Void) {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: ContactStrings.recordTypeKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            
            guard let records = records else { completion(false); return }
            let contacts = records.compactMap( { Contact(ckRecord: $0) } )
            
            self.contacts = contacts
            completion(true)
        }
    }
    
    // Update
    func updateContact(contact: Contact, completion: @escaping (Bool) -> Void) {
        
        let operation = CKModifyRecordsOperation(recordsToSave: [CKRecord(contact: contact)], recordIDsToDelete: nil)
        
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInitiated
        operation.queuePriority = .high
        operation.completionBlock = {
            completion(true)
            print("Contact was updated successfully")
        }
        
        publicDB.add(operation)
    }
}
