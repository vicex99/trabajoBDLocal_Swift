//
//  Repository.swift
//  ChrismastDinner
//
//  Created by VICTOR ALVAREZ LANTARON on 9/1/19.
//  Copyright © 2019 victorSL. All rights reserved.
//

import Foundation

protocol Repository {
    associatedtype T
    
    func getAll() -> [T]
    func get(identifier:String) -> T?
    func create(a: T) -> Bool
    func delete(a: T) -> Bool
    func update(a: T) -> Bool
}
