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
    
    static func saveObject(_ task: Task) {
        try! realm.write {
            realm.add(task)
        }
    }
    static func deleteObject(_ task: Task) {
        
        try! realm.write {
            realm.delete(task)
        }
    }
}
