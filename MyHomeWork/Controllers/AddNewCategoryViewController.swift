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
    
    var redColor: Float = 1.0
    var greenColor: Float = 1.0
    var blueColor: Float = 0.0
    
    @IBOutlet weak var titleLable: UITextField!
    
    @IBOutlet weak var subtitleLabel: UITextField!
    
    @IBOutlet weak var addTaskOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedCategories = realm.objects(Category.self)
        
        addTaskOutlet.isEnabled = false
        
        //функция из расширения для скрытия клавиатуры
        self.hideKeyboardWhenTappedAround()
        
        subtitleLabel.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)//при редактировании поля срабатывает и вызывает textFieldChanged
        
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
    
    
    
    
    
    
    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        if subtitleLabel.text != "" {

            var category = Category()
            var countOfCategory: Int = 0
            for i in savedCategories {
                countOfCategory = i.numberOfCategory
            }
            
            let newTask = Category(name: subtitleLabel.text!, redColor: redColor, greenColor: greenColor, blueColor: blueColor, numberOfCategory: countOfCategory + 1)
            
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
        case 2://зелённый
            redColor = 0.0
            greenColor = 1.0
            blueColor = 0.0
        case 3://коричневый
            redColor = 0.6
            greenColor = 0.4
            blueColor = 0.2
        case 4://бирюзовый
            redColor = 0.0
            greenColor = 1.0
            blueColor = 1.0
        case 5://маджента
            redColor = 1.0
            greenColor = 0.0
            blueColor = 1.0
        case 6://оранжевый
            redColor = 1.0
            greenColor = 0.5
            blueColor = 0.0
        default:
            redColor = 1.0
            greenColor = 1.0
            blueColor = 0.0
        }
        
    }
    
    
}

//скрыываем клавиатуру при нажатии
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
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
        } else {
            addTaskOutlet.isEnabled = false
        }
    }
}
