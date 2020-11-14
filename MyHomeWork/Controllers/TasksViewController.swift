//
//  TasksViewController.swift
//  MyHomeWork
//
//  Created by Игорь Ноек on 11.05.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import RealmSwift

protocol updateTable {
    func tableReloadData()
}

class TasksViewController: UIViewController, updateTable {
    
    var categoriesArray: [String] = []

    
    func tableReloadData() {
        table.reloadData()
    }
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    var alert: UIAlertController! = nil
    
    var currentId = ""
    var number = 0
    var id: String = ""
    var categoryOfEditingTask = 0
    
    var titleOfTask: String = ""
    var definision: String?
    
    var red: Float = 0.0
    var green: Float = 0.0
    var blue: Float = 0.0
    
    var categoryTitle = ""

    var taskForChangeId = ""
    
    var tasks = Task()
    
    private var savedTasks: Results<Task>!
    private var savedCategories: Results<Category>!
    
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedTasks = realm.objects(Task.self).filter("numberOfCategory == \(number)")
        savedCategories = realm.objects(Category.self)
        
        categoryLabel.backgroundColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 0.6)
        categoryLabel.text = categoryTitle
        
        table.tableFooterView = UIView()
        
        //table.register(NewTaskTableViewCell.self, forCellReuseIdentifier: "editTasks")
    }
    
    //MARK: -Add Task
    @IBAction func addButtonTapped(_ sender: UIButton) {
        if number > 0 {
            let currentTasks = realm.objects(Task.self)
            
            //var taskID = currentTasks.endIndex
            
            let taskID = StorageManager.autoIncrement(id: currentTasks.endIndex)
            
            let identifier = UUID().uuidString
            
            
            let newTask = Task(ID: identifier, name: "Нажмите сюда...", definision: "", numberOfCategory: number, completed: false)
            
            StorageManager.saveTask(newTask)
            table.reloadData()
            print("Добавляем задачу в категорию: \(number)")
        }
    }
    
//MARK: -Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTasks" {
            if let editVC = segue.destination as? DetailTaskViewController {
                editVC.titleTask = titleOfTask
                editVC.definisionTask = definision ?? ""
                editVC.id = id
                editVC.categoryOfEditingTask = categoryOfEditingTask
                editVC.delegate = self
            }
        }
        
        if segue.identifier == "changeCategory" {
            if let changeVC = segue.destination as? ChangeCategoryViewController {
                changeVC.taskId = taskForChangeId
                changeVC.delegate = self
            }
        }

    }
    

    
    
    
}

//MARK: -Setup TableView
extension TasksViewController: UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedTasks.isEmpty ? 0 : savedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell3 = table.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TasksTableViewCell
        
        var task = Task()
        task = savedTasks[indexPath.row]
        
        cell3.titleLabel.text = task.name
       // cell3.definisionLabel.text = task.definision
        
        let stringData = task.date
 
        let df = DateFormatter()
        df.dateFormat = "dd MMM yyyy г., HH:mm"
        df.locale = Locale(identifier: "ru_Ru")
        let now = df.string(from: stringData)
        
        cell3.definisionLabel.text = "Последнее редактирование: \(now)"
        
        
        if task.completed {
            cell3.completeImageView.alpha = 0.3
        } else if task.completed == false {
            cell3.completeImageView.alpha = 0
        }
        
        
        //cell.textLabel?.text = task.name
        
        return cell3
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        var task = Task()
        
        task = savedTasks[indexPath.row]
        
        
        titleOfTask = task.name
        definision = task.definision
        print(task.ID, id)
        id = task.ID
        categoryOfEditingTask = task.numberOfCategory
        
        self.performSegue(withIdentifier: "editTasks", sender: self)
    }
    
    //удаляем объект из базы данных и интерфейса
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = savedTasks[indexPath.row]
        let delete = UIContextualAction(style: .normal, title: "Удалить") { (_, _, _) in
            StorageManager.deleteTask(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            
        }
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let task = savedTasks[indexPath.row]
        let copmplete = UIContextualAction(style: .normal, title: "Выполнено") { (_, _, _) in

            if task.completed == false {
                try! realm.write {
                    task.completed = true
                }
            } else if task.completed {
                try! realm.write {
                    task.completed = false
                }
            }
            tableView.reloadData()
        }
        copmplete.backgroundColor = .systemGreen
        
        return UISwipeActionsConfiguration(actions: [copmplete])
    }
    
    //MARK: -Context Menu
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        // 1
        let index = indexPath.row
        var task = savedTasks[index]
        var categoryCount = savedCategories.count
        for i in self.savedCategories {
            categoriesArray.append(i.name)
        }
        
        // 2
        let identifier = "\(index)" as NSString
        
        return UIContextMenuConfiguration(
            identifier: identifier,
            previewProvider: nil) { _ in
            // 3
            let mapAction = UIAction(
                title: "Переименовать",
                image: UIImage(systemName: "pencil", withConfiguration: UIImage.SymbolConfiguration(weight: .black))?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)) { _ in
                self.currentId = task.ID
                self.showAlert()
            }
                
                // 4
            let shareAction = UIAction(
                title: "Переместить...",
                image: UIImage(systemName: "bubble.left.and.bubble.right.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .black))?.withTintColor(.systemBlue, renderingMode: .alwaysOriginal)) { _ in
                self.taskForChangeId = task.ID
                self.performSegue(withIdentifier: "changeCategory", sender: self)
                print("Количество категорий \(categoryCount), название категорий \(self.categoriesArray)")
            }
                


                
                // 5
            return UIMenu(title: "", image: nil, children: [mapAction, shareAction])
        }
        
    }

    
}


//MARK: -Create Alert Controller For Add Quick Task
extension TasksViewController {
    
    
    private func showAlert() {
        
        alert = UIAlertController(title: "Введите задачу", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Введите ваш текст"
        }
        let addTask = UIAlertAction(title: "Сохранить", style: .default) { (button) in
            guard let text = self.alert.textFields!.first?.text else { return }
            if text != "" && self.currentId != "" {

                guard let task = realm.object(ofType: Task.self, forPrimaryKey: self.currentId) else { return }
               // let textField = self.alert.textFields![0]

                    try! realm.write {
                        task.name = text
                        task.date = Date()
                        self.currentId = ""
                    }
                self.table.reloadData()
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
