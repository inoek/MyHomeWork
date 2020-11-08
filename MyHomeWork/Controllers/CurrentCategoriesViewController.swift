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
    var alert: UIAlertController! = nil
    
    var num = 0
    var idd = 0
    
    var red: Float = 0.0
    var green: Float = 0.0
    var blue: Float = 0.0
    var categoryTitle = ""
    
    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        print(Realm.Configuration.defaultConfiguration.fileURL!)
        savedCategories = realm.objects(Category.self)
        savedTasks = realm.objects(Task.self)
        
        
        if savedCategories.isEmpty {
            let defaultCategory = Category(name: "Неподшитые записи", redColor: 1.0, greenColor: 1.0, blueColor: 0.0, numberOfCategory: 1)
            
            StorageManager.saveObject(defaultCategory)
        }
        
        //table.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        table.tableFooterView = UIView()
    }
    
    
    
    
    //MARK: -Navigation
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard segue.source is AddNewCategoryViewController  else {return}
        //        newPLaceVC.savePlace()
        
        table.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTasks" {
            if let taskVC = segue.destination as? TasksViewController {
                if num > 0 {
                    taskVC.number = num
                    taskVC.red = red
                    taskVC.green = green
                    taskVC.blue = blue
                    taskVC.categoryTitle = categoryTitle
                }
            }
        }
    }
    
    @IBAction func createQuickTaskTapped(_ sender: UIButton) {
        showAlert()
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
        
        
        cell.categoryLabel.text = category.name
        //cell.nameLabel.text = category.name
        cell.backgroundColor = UIColor(red: CGFloat(category.redColor), green: CGFloat(category.greenColor), blue: CGFloat(category.blueColor), alpha: 0.6)
        
        //cell.textLabel?.text = "w"
        
        let viewSeparatorLine = UIView(frame:CGRect(x: 0, y: cell.contentView.frame.size.height + 8.0, width: cell.contentView.frame.size.width, height: 8))
        cell.contentView.addSubview(viewSeparatorLine)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 12
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 20
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        var category = Category()
        category = savedCategories[indexPath.row]
        
        
        
        red = category.redColor
        green = category.greenColor
        blue = category.blueColor
        
        num = category.numberOfCategory
        
        categoryTitle = category.name
        
        
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

//MARK: -Create Alert Controller For Add Quick Task
extension CurrentCategoriesViewController {
    
    
    private func showAlert() {
        // var test: String
        
        alert = UIAlertController(title: "Введите задачу", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Введите ваш текст"
        }
        let addTask = UIAlertAction(title: "Добавить", style: .default) { (button) in
            guard let text = self.alert.textFields!.first?.text else { return }
            if text != "" {
                let taskID = StorageManager.autoIncrement(id: self.savedTasks.count)
                
                let identifier = UUID().uuidString
                
                let newTask = Task(ID: identifier, name: text, definision: "", numberOfCategory: 1, completed: false)
                
                StorageManager.saveTask(newTask)
            }
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .destructive, handler: nil)
        
        let heightOfTheAlert = NSLayoutConstraint(item: alert.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 150)
        alert.view.addConstraint(heightOfTheAlert)
        
        alert.addAction(addTask)
        
        alert.addAction(cancel)
        present(alert, animated: true)
        
    }
    
}


