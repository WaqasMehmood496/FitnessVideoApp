//
//  PrivacyPolicyViewController.swift
//  FitnessVideoApp
//
//  Created by Buzzware Tech on 15/06/2021.
//  Copyright © 2021 Asadullah. All rights reserved.

import UIKit

class PrivacyPolicyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
       
    }

    @IBAction func BackBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
