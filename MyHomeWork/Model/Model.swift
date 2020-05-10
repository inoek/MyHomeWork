//
//  Model.swift
//  MyHomeWork
//
//  Created by Игорь Ноек on 09.05.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import RealmSwift

class Task: Object {

    @objc dynamic var category: String?
    @objc dynamic var name = ""


    convenience init(category: String?, name: String) {//инициализатор модели
        self.init()//вызываем инициализатор класса
        self.name = name
        self.category = category
    }

}
