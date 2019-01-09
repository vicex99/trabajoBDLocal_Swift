//
//  participantEntity.swift
//  ChrismastDinner
//
//  Created by VICTOR ALVAREZ LANTARON on 9/1/19.
//  Copyright © 2019 victorSL. All rights reserved.
//

import UIKit
import RealmSwift

class ParticipantEntity: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var dateParticipant = Date()
    @objc dynamic var paid = false
    
    convenience init (id: String, name: String, dateParticipant: Date, paid: Bool) {
        self.init()
        self.id = id
        self.name = name
        self.dateParticipant = dateParticipant
        self.paid = paid
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func ParticipantModel() -> Participant {
        let model = Participant()
        model.id = id
        model.myName = name
        model.myDateParticipation = dateParticipant
        model.paid = paid
        return model
    }
}
