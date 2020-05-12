//
//  TasksViewController.swift
//  MyHomeWork
//
//  Created by Игорь Ноек on 11.05.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import RealmSwift

class TasksViewController: UIViewController {
    
    var number = 0
    var id = 0
    var categoryOfEditingTask = 0
    
    var titleOfTask: String = ""
    var definision: String?
    
    var tasks = Task()
    
    private var savedTasks: Results<Task>!

    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedTasks = realm.objects(Task.self).filter("numberOfCategory == \(number)")
        
        //table.register(NewTaskTableViewCell.self, forCellReuseIdentifier: "editTasks")
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        if number > 0 {
        let    currentTasks = realm.objects(Task.self)

            var taskID = currentTasks.count
            
            
            let newTask = Task(ID: taskID + 1, name: "Нажмите сюда...", definision: "", numberOfCategory: number)
            
            StorageManager.saveTask(newTask)
            table.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTasks" {
            if let editVC = segue.destination as? ContexTestViewController {
                editVC.titleTask = titleOfTask
                editVC.definisionTask = definision ?? ""
                editVC.id = id
                editVC.categoryOfEditingTask = categoryOfEditingTask
            }
        }
    }
    
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        
        table.reloadData()
    }

}


extension TasksViewController: UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedTasks.isEmpty ? 0 : savedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell3 = table.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TasksTableViewCell
        
        var task = Task()
        task = savedTasks[indexPath.row]
        
        cell3.titleLabel.text = task.name
        cell3.definisionLabel.text = task.definision
        
 
        
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
    
    
}
