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
    
    var tasks = Task()
    
    private var savedTasks: Results<Task>!

    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedTasks = realm.objects(Task.self).filter("numberOfCategory == \(number)")
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        if number > 0 {
            let newTask = Task(name: "Нажмите сюда...", definision: "", numberOfCategory: number)
            
            StorageManager.saveTask(newTask)
            table.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//               if segue.identifier == "showTasks" {
//             if let taskVC = segue.destination as? TasksViewController {
//                 if num > 0 {
//                    taskVC.number = num
//                     print("num is \(num)")
//                 }
//             }
//         }
    }

}


extension TasksViewController: UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedTasks.isEmpty ? 0 : savedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var task = Task()
        task = savedTasks[indexPath.row]
        
        cell.textLabel?.text = task.name
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                table.deselectRow(at: indexPath, animated: true)

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
