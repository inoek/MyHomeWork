//
//  AddCategoryViewController.swift
//  MyHomeWork
//
//  Created by Игорь Ноек on 11.05.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import RealmSwift

class AddTaskViewController: UIViewController {

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

                
            let newTask = Task(ID: taskID + 1, name: textField.text!, definision: "", numberOfCategory: 1)
                
                StorageManager.saveTask(newTask)
            
        }
        
    }
    
}
    
//extension AddTaskViewController: UITableViewDelegate ,UITableViewDataSource {
//    
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//            
//            return savedCategories.isEmpty ? 0 : savedCategories.count
//        }
//        
//
//        
//
//        
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell2 = table.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewTaskTableViewCell
//            
//            var category = Category()
//            category = savedCategories[indexPath.row]
//            
//
//                cell2.fLabel.text = "w"
//                cell2.sLabel.text = category.name
//                cell2.backgroundColor = UIColor(red: CGFloat(category.redColor), green: CGFloat(category.greenColor), blue: CGFloat(category.blueColor), alpha: 1.0)
//            
//
//
//            return cell2
//        }
//        
//        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 90
//        }
//        
//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            table.deselectRow(at: indexPath, animated: true)
//            var category = Category()
//            category = savedCategories[indexPath.row]
//           // print(category.numberOfCategory)
//            catNum = category.numberOfCategory
//        }
//    
//}
