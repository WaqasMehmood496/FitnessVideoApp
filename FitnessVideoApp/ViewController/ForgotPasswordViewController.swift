//
//  ForgotPasswordViewController.swift
//  FitnessVideoApp
//
//  Created by Asad on 04/03/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var emailView: UIView!
    
    @IBOutlet weak var resetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.cornerRadius =  mainView.bounds.size.height/10
        
        emailView.layer.cornerRadius = emailView.bounds.size.height/2
        
        resetBtn.layer.cornerRadius = resetBtn.bounds.size.height/2
  
    }
    


}
