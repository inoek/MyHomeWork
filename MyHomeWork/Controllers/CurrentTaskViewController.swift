//
//  CurrentTaskViewController.swift
//  MyHomeWork
//
//  Created by Игорь Ноек on 09.05.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import RealmSwift

class CurrentTaskViewController: UIViewController {
    
    private var savedTracks: Results<Task>!
    
    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedTracks = realm.objects(Task.self)
        //table.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        table.tableFooterView = UIView()
    }
    
    
    
    
    //MARK: -Navigation
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard segue.source is AddNewTaskViewController else {return}
        //        newPLaceVC.savePlace()
        
        table.reloadData()
    }
    
    
    
}

//MARK: -TableView setup
extension CurrentTaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return savedTracks.isEmpty ? 0 : savedTracks.count
    }
    
//    func colorForIndex(_ index: Int) -> UIColor {
//        let itemCount = savedTracks.count - 1
//        let val = (CGFloat(index) / CGFloat(itemCount)) * 1.6
//        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        var task = Task()
        task = savedTracks[indexPath.row]
        
        //cell.textLabel?.text = "w"
        cell.categoryLabel.text = task.category
        cell.nameLabel.text = task.name
        //cell.backgroundColor = colorForIndex(indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "test", sender: self)
    }
    
    //удаляем объект из базы данных и интерфейса
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = savedTracks[indexPath.row]
        let delete = UIContextualAction(style: .normal, title: "Удалить") { (_, _, _) in
            StorageManager.deleteObject(task)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        delete.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
}
