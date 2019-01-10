      //
//  LocalDinnerRepository.swift
//  ChrismastDinner
//
//  Created by VICTOR ALVAREZ LANTARON on 9/1/19.
//  Copyright © 2019 victorSL. All rights reserved.
//

import Foundation
import RealmSwift

class LocalDinnerRepository: Repository {
    
    func getAll() -> [Participant] {
        var participants: [Participant] = []
        
        do {
            let entities = try Realm().objects(ParticipantEntity.self).sorted(byKeyPath: "dateParticipant", ascending: false)
            
            for entity in entities {
                let model = entity.ParticipantModel()
                participants.append(model)
            }
        }
        catch let error as NSError {
            print("ERROR getAll: ", error.description)
        }
        return participants
    }
    
    func get(identifier:String) -> Participant? {
        do {
            let realm = try! Realm()
            if let entity = realm.objects(ParticipantEntity.self).filter("id == %@",identifier).first {
                let model = entity.ParticipantModel()
                return model
            }
        }
        return nil
    }
    
    func get(name:String) -> Participant? {
        do {
            let realm = try! Realm()
            if let entity = realm.objects(ParticipantEntity.self).filter("name == %@",name).first {
                let model = entity.ParticipantModel()
                return model
            }
        }
        return nil
    }
    
    func create(a: Participant) -> Bool {
        do {
            let realm = try! Realm()
            let entity = ParticipantEntity(id: a.id, name: a.myName, dateParticipant: a.myDateParticipation, paid: a.paid)
            
            try realm.write {
                // El metodo update: true indica que si encuentra uno igual lo replaza
                realm.add(entity, update: true)
            }
        } catch {
            return false
        }
        return true
    }
    
    func delete(a: Participant) -> Bool {
        do{
            let realm = try Realm()
            try realm.write {
                let entryToDelete = realm.objects(ParticipantEntity.self).filter("name == %@", a.myName)
                realm.delete(entryToDelete)
            }
        }
        catch {
            return false
        }
        return true
    }
    
    func update(a: Participant) -> Bool {
       return create(a: a)
       
    }

}
