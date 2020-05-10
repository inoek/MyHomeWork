//
//  TransitViewController.swift
//  MyHomeWork
//
//  Created by Игорь Ноек on 09.05.2020.
//  Copyright © 2020 Игорь Ноек. All rights reserved.
//

import UIKit
import SwiftUI

class TransitViewController: UIHostingController<CurrentTasks> {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder,rootView: CurrentTasks())
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBSegueAction func transitSegue(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: CurrentTasks())
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
