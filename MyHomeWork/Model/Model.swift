//
//  Model.swift
//  MyHomeWork
//
//  Created by Игорь Ноек on 09.05.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import RealmSwift

class Category: Object {

    @objc dynamic var name = ""
    @objc dynamic var redColor: Float = 0.0
    @objc dynamic var greenColor: Float = 0.0
    @objc dynamic var blueColor: Float = 0.0
    @objc dynamic var numberOfCategory: Int = 0

    convenience init(name: String, redColor: Float, greenColor: Float, blueColor: Float, numberOfCategory: Int) {//инициализатор модели
        self.init()//вызываем инициализатор класса
        self.name = name
        self.redColor = redColor
        self.greenColor = greenColor
        self.blueColor = blueColor
        self.numberOfCategory = numberOfCategory
    }

}

class Task: Object {
    @objc dynamic var ID = 1
    @objc dynamic var name = ""
    @objc dynamic var definision = ""
    @objc dynamic var numberOfCategory: Int = 0
    @objc dynamic var completed = false
    convenience init(ID: Int, name: String, definision: String, numberOfCategory: Int, completed: Bool) {//инициализатор модели
        self.init()//вызываем инициализатор класса
        self.ID = ID
        self.name = name
        self.definision = definision
        self.numberOfCategory = numberOfCategory
        self.completed = completed
    }
}


