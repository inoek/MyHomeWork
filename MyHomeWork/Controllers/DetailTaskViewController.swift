//
//  ContexTestViewController.swift
//  MyHomeWork
//
//  Created by Игорь Ноек on 10.05.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import RealmSwift

class DetailTaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var delegate: updateTable?
    
    @IBOutlet weak var definisionTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var titleTask = ""
    var definisionTask = ""
    
    var id = ""
    var categoryOfEditingTask = 0
    
    var dayAndMonth = ""
    
    private var currentTask: Results<Task>!
    private var currentTask2: Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        titleTextField.delegate = self
        titleTextField.text = titleTask
        
        currentTask = realm.objects(Task.self)
        
        let interaction = UIContextMenuInteraction(delegate: self)
        imageView.addInteraction(interaction)
        imageView.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func pickDate(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        let dateToString = dateFormatter.string(from: sender.date)
        
        dayAndMonth = dateToString
        print(dayAndMonth)
    }
    
    
    //MARK: -Update Task
    @IBAction func saveTask(_ sender: UIButton) {
                
        guard let task = realm.object(ofType: Task.self, forPrimaryKey: id) else { return }
        guard let titleText = titleTextField.text else { return }
        
        try! realm.write {
            task.deadline  = dayAndMonth
            task.name = titleText
            task.definision = definisionTextView.text ?? ""
            task.date = Date()
        }
        dismiss(animated: true, completion: nil)
        
        delegate?.tableReloadData()
        
    }
    @IBAction func exitTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension DetailTaskViewController: UIContextMenuInteractionDelegate {
    func createContextMenu() -> UIMenu {
        let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
            print("Share")
            let image = self.imageView.image
            let imageToShare = [ image! ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            
            self.present(activityViewController, animated: true, completion: nil)
        }
        let copy = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { _ in
            print("Copy")
            UIPasteboard.general.image = self.imageView.image
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
extension DetailTaskViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddNewCategoryViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

//MARK: -Hide Keyboard
extension DetailTaskViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 150 //keyboardSize.height / 2
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                    self.imageView.alpha = 0
                    
                }, completion: nil)
                
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.imageView.alpha = 1
            }, completion: nil)
            
            
            
        }
    }
    
}

