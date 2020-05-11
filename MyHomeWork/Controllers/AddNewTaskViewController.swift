//
//  AddNewTaskViewController.swift
//  MyHomeWork
//
//  Created by Игорь Ноек on 09.05.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import RealmSwift

class AddNewTaskViewController: UIViewController {
    
    @IBOutlet weak var titleLable: UITextField!
    
    @IBOutlet weak var subtitleLabel: UITextField!
    
    @IBOutlet weak var addTaskOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            let   newTask = Task(category: titleLable.text, name: subtitleLabel.text!)
            StorageManager.saveObject(newTask)
            
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

extension AddNewTaskViewController: UITextFieldDelegate {
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
