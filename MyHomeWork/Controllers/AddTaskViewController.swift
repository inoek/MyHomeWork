//
//  AddCategoryViewController.swift
//  MyHomeWork
//
//  Created by Игорь Ноек on 11.05.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import RealmSwift

class QuikTaskViewController: UIViewController {

    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var definisionTextField: UITextField!
    
    private var savedCategories: Results<Category>!
    
    private var savedTasks: Results<Task>!

    
    var catNum = 0


    @IBOutlet weak var table: UITableView!
    
    
    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedCategories = realm.objects(Category.self)
        
        savedTasks = realm.objects(Task.self)

       // table.register(NewTaskTableViewCell.self, forCellReuseIdentifier: "Cell")
       // table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")


    }
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        if textField.text != "" {


                var task = Task()
            
            var taskID = savedTasks.count

                
            let newTask = Task(ID: taskID + 1, name: titleTextField.text!, definision: definisionTextField.text, numberOfCategory: 1)
                
                StorageManager.saveTask(newTask)
            

        }
        dismiss(animated: true, completion: nil)

    }

    
}
    
