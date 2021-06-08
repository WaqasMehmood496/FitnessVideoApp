//
//  selectDesignViewController.swift
//  FitnessVideoApp
//
//  Created by Asad on 05/03/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit

class selectDesignViewController: UIViewController {


    @IBOutlet weak var startBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func StartBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func BackBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
