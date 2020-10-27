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
    
    var delegate: updateTable?
    
    @IBOutlet weak var defenisionTextViewOutlet: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    
    var titleTask = ""
    var definisionTask = ""
    
    var id = ""
    var categoryOfEditingTask = 0
    
    private var currentTask: Results<Task>!
    private var currentTask2: Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        
        titleTextField.text = titleTask
        defenisionTextViewOutlet.text = definisionTask
        
    //    currentTask = realm.objects(Task.self).filter("ID == \(id)")
        currentTask = realm.objects(Task.self)

        let interaction = UIContextMenuInteraction(delegate: self)
        imageView.addInteraction(interaction)
        imageView.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
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
    //MARK: -Update Task
    @IBAction func saveTask(_ sender: UIButton) {
        
        // var taskID = savedTasks.count
//        var qq = Task()
//        for i in currentTask {
//            if i.ID == id {
//                qq = i
//            }
//        }

        
//        for i in currentTask {
//            if i.ID == id {
//             task = i
//            }
//        }
        
        //let myPrimaryKey = id
        
        guard let task = realm.object(ofType: Task.self, forPrimaryKey: id) else { return }
        

            try! realm.write {
                task.name = titleTextField.text ?? ""
                task.definision = defenisionTextViewOutlet.text ?? ""
                task.date = Date()
            }
            dismiss(animated: true, completion: nil)
        
        delegate?.tableReloadData()
        
    }
    @IBAction func exitTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension ContexTestViewController: UIContextMenuInteractionDelegate {
    func createContextMenu() -> UIMenu {
        let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { _ in
            print("Share")
            let image = self.imageView.image
            let imageToShare = [ image! ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // exclude some activity types from the list (optional)
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
            
            // present the view controller
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
extension ContexTestViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddNewCategoryViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
