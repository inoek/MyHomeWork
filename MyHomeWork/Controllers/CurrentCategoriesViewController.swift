//
//  CurrentTaskViewController.swift
//  MyHomeWork
//
//  Created by Игорь Ноек on 09.05.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import RealmSwift

class CurrentCategoriesViewController: UIViewController {
    
    private var savedCategories: Results<Category>!
    private var savedTasks: Results<Task>!
    
    var num = 0
    var idd = 0
    
    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedCategories = realm.objects(Category.self)
        
        
        if savedCategories.isEmpty {
            let defaultCategory = Category(name: "Неподшитые записи", redColor: 1.0, greenColor: 1.0, blueColor: 0.0, numberOfCategory: 1)
            
            StorageManager.saveObject(defaultCategory)
        }
        
        //table.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        table.tableFooterView = UIView()
    }
    
    
    
    
    //MARK: -Navigation
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        //guard segue.source is AddNewCategoryViewController  else {return}
        //        newPLaceVC.savePlace()
        
        table.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTasks" {
            if let taskVC = segue.destination as? TasksViewController {
                if num > 0 {
                   taskVC.number = num
 //                   taskVC.id = idd
                }
            }
        }
    }
    
    
    
}

//MARK: -TableView setup
extension CurrentCategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return savedCategories.isEmpty ? 0 : savedCategories.count
    }
    
    //    func colorForIndex(_ index: Int) -> UIColor {
    //        let itemCount = savedTracks.count - 1
    //        let val = (CGFloat(index) / CGFloat(itemCount)) * 1.6
    //        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    //    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        var category = Category()
        category = savedCategories[indexPath.row]
        
        
        cell.categoryLabel.text = "w"
        cell.nameLabel.text = category.name
        cell.backgroundColor = UIColor(red: CGFloat(category.redColor), green: CGFloat(category.greenColor), blue: CGFloat(category.blueColor), alpha: 1.0)
        
        //cell.textLabel?.text = "w"
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        var category = Category()
        category = savedCategories[indexPath.row]
        
 //       let numberOfCat = category.numberOfCategory
        
 //       savedTasks = realm.objects(Task.self).filter("numberOfCategory == \(numberOfCat)")
//        if savedTasks.isEmpty != true {
//            var task = Task()
//            task = savedTasks[indexPath.row]
//
//            idd = task.ID
//        }

        num = category.numberOfCategory


        self.performSegue(withIdentifier: "showTasks", sender: self)
    }
    
    //удаляем объект из базы данных и интерфейса
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let category = savedCategories[indexPath.row]
        
        let numberOfCat = category.numberOfCategory
        
        savedTasks = realm.objects(Task.self).filter("numberOfCategory == \(numberOfCat)")
        var task = [Task]()

        for i in savedTasks {
            task.append(i)
        }
        
        
        guard numberOfCat > 1 else { return nil }
        
        let delete = UIContextualAction(style: .normal, title: "Удалить") { (_, _, _) in
            StorageManager.deleteObject(category)
           // StorageManager.deleteTask(task)
            try! realm.write {
                realm.delete(task)
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
        }
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}
