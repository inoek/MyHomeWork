//
//  ChangeCategoryTableViewCell.swift
//  MyHomeWork
//
//  Created by Игорь Ноек on 08.11.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import RealmSwift

class ChangeCategoryViewController: UIViewController {
    private var savedCategories: Results<Category>!
    private var currentTask: Results<Task>!
    var oldCategoryId = 0
    var taskId = ""
    var delegate: updateTable?
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedCategories = realm.objects(Category.self)
        print(taskId)
    }
    
    
    
    
    
    
}

extension ChangeCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        savedCategories.isEmpty ? 0: savedCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChangeCategoryTableViewCell
        
        let category = savedCategories[indexPath.row]
        
        cell.name.text = category.name
        
        cell.backgroundColor = UIColor(red: CGFloat(category.redColor), green: CGFloat(category.greenColor), blue: CGFloat(category.blueColor), alpha: 0.6)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let verticalPadding: CGFloat = 12
        
        let maskLayer = CALayer()
        maskLayer.cornerRadius = 20
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard  let task = realm.object(ofType: Task.self, forPrimaryKey: taskId) else { return }
        let currentCategory = savedCategories[indexPath.row]
        
        try! realm.write {
            task.numberOfCategory = currentCategory.numberOfCategory
            delegate?.tableReloadData()
        }
        dismiss(animated: true, completion: nil)
    }
    
}

