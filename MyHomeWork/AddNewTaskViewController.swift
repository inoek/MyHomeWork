//
//  AddNewTaskViewController.swift
//  MyHomeWork
//
//  Created by Игорь Ноек on 09.05.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import RealmSwift

class AddNewTaskViewController: UIViewController {

    @IBOutlet weak var titleLable: UITextField!
    
    @IBOutlet weak var subtitleLabel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        if subtitleLabel.text != "" {
          let   newTask = Task(category: titleLable.text, name: subtitleLabel.text!)
            StorageManager.saveObject(newTask)

        }
        
    }
    


}

