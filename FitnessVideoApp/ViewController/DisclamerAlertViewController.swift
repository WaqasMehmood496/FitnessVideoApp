//
//  DisclamerAlertViewController.swift
//  FitnessVideoApp
//
//  Created by Buzzware Tech on 10/08/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit

class DisclamerAlertViewController: UIViewController {

    
    var delegate: FirstPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func CancelBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func ProceedBtnAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.delegate?.createNewAccountDelegate()
        }
    }
    
}

