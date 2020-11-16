//
//  AddNewTaskViewController.swift
//  MyHomeWork
//
//  Created by Игорь Ноек on 09.05.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import RealmSwift

class AddNewCategoryViewController: UIViewController {
    
    private var savedCategories: Results<Category>!
        
    var redColor: Float = 0.5
    var greenColor: Float = 0.0
    var blueColor: Float = 0.5
    
    @IBOutlet weak var titleLable: UITextField!
    
    @IBOutlet weak var subtitleLabel: UITextField!
    
    @IBOutlet weak var addTaskOutlet: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedCategories = realm.objects(Category.self)
        
        addTaskOutlet.isEnabled = false
        
        self.hideKeyboardWhenTappedAround()
        
        subtitleLabel.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)//при редактировании поля срабатывает и вызывает textFieldChanged
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    
    //MARK: -Add Category
    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        if subtitleLabel.text != "" {
            
            var category = StorageManager.autoIncrement(id: savedCategories.endIndex)
            
            
//            var indexOfLastElement: Int = 0
//
//            indexOfLastElement = savedCategories.endIndex
            print("Создаём категорию с идентификатором \(category)")
            for i in savedCategories {
                if category == i.numberOfCategory {
                    category += Int.random(in: 100...1000)
                }
            }
            let newTask = Category(name: subtitleLabel.text!, redColor: redColor, greenColor: greenColor, blueColor: blueColor, numberOfCategory: category)
            
            StorageManager.saveObject(newTask)

        }
        
    }
    
    @IBAction func greenButtonTapped(_ sender: UIButton) {
        //green
        switch sender.tag {
        case 1://красный
            redColor = 1.0
            greenColor = 0.0
            blueColor = 0.0
            addTaskOutlet.backgroundColor = .red
            
        case 2://зелённый
            redColor = 0.0
            greenColor = 1.0
            blueColor = 0.0
            addTaskOutlet.backgroundColor = .green
            
            
        case 3://коричневый
            redColor = 0.6
            greenColor = 0.4
            blueColor = 0.2
            addTaskOutlet.backgroundColor = .brown
            
            
        case 4://бирюзовый
            redColor = 0.0
            greenColor = 1.0
            blueColor = 1.0
            addTaskOutlet.backgroundColor = .cyan
            
            
        case 5://маджента
            redColor = 1.0
            greenColor = 0.0
            blueColor = 1.0
            addTaskOutlet.backgroundColor = .magenta
            
            
        case 6://оранжевый
            redColor = 1.0
            greenColor = 0.5
            blueColor = 0.0
            addTaskOutlet.backgroundColor = .orange
            
        case 7://синий
            redColor = 0.0
            greenColor = 0.0
            blueColor = 1.0
            addTaskOutlet.backgroundColor = .blue
            
        case 8://фиолетовый
            redColor = 0.5
            greenColor = 0.0
            blueColor = 0.5
            addTaskOutlet.backgroundColor = .purple
            
            
        default:
            redColor = 0.5
            greenColor = 0.0
            blueColor = 0.5
            addTaskOutlet.backgroundColor = .purple
        }
        
    }
    
    
}

//скрыываем клавиатуру при нажатии
extension AddNewCategoryViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddNewCategoryViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AddNewCategoryViewController: UITextFieldDelegate {
    //скрываем клавиатуру по нажатию на done
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        textField.resignFirstResponder()
    //        return true
    //    }
    @objc private func textFieldChanged() { //проверяем заполненность поля subtitle
        if subtitleLabel.text?.isEmpty == false {
            addTaskOutlet.isEnabled = true
            addTaskOutlet.alpha = 1
        } else {
            addTaskOutlet.isEnabled = false
            addTaskOutlet.alpha = 0.2
        }
    }
}
//MARK: -Show/Hide Keyboard
extension AddNewCategoryViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 1
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
