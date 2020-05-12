//
//  ContexTestViewController.swift
//  MyHomeWork
//
//  Created by Игорь Ноек on 10.05.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import RealmSwift

class ContexTestViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var definisionTextField: UITextField!
    
    var titleTask = ""
    var definisionTask = ""
    
    var id = 0
    var categoryOfEditingTask = 0
    
    private var currentTask: Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextField.text = titleTask
        definisionTextField.text = definisionTask
        
        currentTask = realm.objects(Task.self).filter("ID == \(id)")
        
        let interaction = UIContextMenuInteraction(delegate: self)
        imageView.addInteraction(interaction)
        imageView.isUserInteractionEnabled = true
        
    }
    
    @IBAction func saveTask(_ sender: UIButton) {
        
       // var taskID = savedTasks.count
        
        
        if let task = currentTask.first {
            try! realm.write {
                task.name = titleTextField.text ?? ""
                task.definision = definisionTextField.text
            }
        }
       // table.reloadData()
        
    }
    
}

extension ContexTestViewController: UIContextMenuInteractionDelegate {
    func createContextMenu() -> UIMenu {
    let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
    print("Share")
    }
    let copy = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { _ in
    print("Copy")
    }
    let saveToPhotos = UIAction(title: "Add To Photos", image: UIImage(systemName: "photo")) { _ in
    print("Save to Photos")
    }
    return UIMenu(title: "", children: [shareAction, copy, saveToPhotos])
    }

    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
    return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
    return self.createContextMenu()
        }
    }
    
    
}
