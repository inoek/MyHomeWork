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
        

    }

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let addTaskVC = segue.source as? AddNewTaskViewController else {return}
//        newPLaceVC.savePlace()
        
        table.reloadData()
    }


}


extension CurrentTaskViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return savedTracks.isEmpty ? 0 : savedTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        
        var task = Task()
        task = savedTracks[indexPath.row]
        
        //cell.textLabel?.text = "w"
        cell.categoryLabel.text = task.category
        cell.nameLabel.text = task.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
