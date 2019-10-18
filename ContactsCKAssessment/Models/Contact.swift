//
//  Contact.swift
//  ContactsCKAssessment
//
//  Created by Austin Goetz on 10/18/19.
//  Copyright © 2019 Austin Goetz. All rights reserved.
//

import Foundation
import CloudKit

struct ContactStrings {
    
    static let recordTypeKey = "Contact"
    static let nameKey = "name"
    static let phoneNumberKey = "phoneNumber"
    static let emailKey = "email"
}

class Contact {
    
    let name: String
    let phoneNumber: String?
    let email: String?
    let ckRecordID: CKRecord.ID
    
    init(name: String, phoneNumber: String?, email: String?, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.ckRecordID = ckRecordID
    }
}

// User <- Cloud
extension Contact {
    
    convenience init?(ckRecord: CKRecord) {
        
        guard let name = ckRecord[ContactStrings.nameKey] as? String,
            let phoneNumber = ckRecord[ContactStrings.phoneNumberKey] as? String,
            let email = ckRecord[ContactStrings.emailKey] as? String
            else { return nil }
            
        self.init(name: name, phoneNumber: phoneNumber, email: email, ckRecordID: ckRecord.recordID)
    }
}

// User -> Cloud
extension CKRecord {
    
    convenience init(contact: Contact) {
        
        self.init(recordType: ContactStrings.recordTypeKey, recordID: contact.ckRecordID)
        setValue(contact.name, forKey: ContactStrings.nameKey)
        setValue(contact.phoneNumber, forKey: ContactStrings.phoneNumberKey)
        setValue(contact.email, forKey: ContactStrings.emailKey)
    }
}
