//
//  DetailVC.swift
//  Sqlite Demo
//
//  Created by Gourav on 15/02/20.
//  Copyright © 2020 Gourav. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    var mainView : UserListVC?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func back(_ sender: Any) {
        mainView?.getData(str: "This is from second")
        navigationController?.popViewController(animated: true)
    }
}


