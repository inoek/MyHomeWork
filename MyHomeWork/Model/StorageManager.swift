//
//  StorageManager.swift
//  MyHomeWork
//
//  Created by Игорь Ноек on 09.05.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ category: Category) {
        try! realm.write {
            realm.add(category)
        }
    }
    static func deleteObject(_ category: Category) {
        
        try! realm.write {
            realm.delete(category)
        }
    }
    
    static func saveTask(_ task: Task) {
        try! realm.write {
            realm.add(task)
        }
    }
    static func deleteTask(_ task: Task) {
        
        try! realm.write {
            realm.delete(task)
        }
    }
    
    static func autoIncrement(id: Int) -> Int {
        return id + 1
    }
}
