//
//  AddCategoryViewController.swift
//  MyHomeWork
//
//  Created by Игорь Ноек on 11.05.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import RealmSwift

class QuikTaskViewController: UIViewController {

    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var definisionTextField: UITextField!
    
    private var savedCategories: Results<Category>!
    
    private var savedTasks: Results<Task>!

    
    var catNum = 0


    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedCategories = realm.objects(Category.self)
        
        savedTasks = realm.objects(Task.self)

       // table.register(NewTaskTableViewCell.self, forCellReuseIdentifier: "Cell")
       // table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.hideKeyboardWhenTappedAround()
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
            
        }
        
        
        @objc func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height / 2
                }
            }
        }
        
        @objc func keyboardWillHide(notification: NSNotification) {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        if titleTextField.text != "" || definisionTextField.text != "" {


                var task = Task()
            
            var taskID = savedTasks.count

                

            
            let newTask = Task(ID: taskID + 1, name: titleTextField.text!, definision: definisionTextField.text!, numberOfCategory: 1, completed: false)
                
                StorageManager.saveTask(newTask)
            

        }
        dismiss(animated: true, completion: nil)

    }

    
}
    
extension QuikTaskViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddNewCategoryViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
