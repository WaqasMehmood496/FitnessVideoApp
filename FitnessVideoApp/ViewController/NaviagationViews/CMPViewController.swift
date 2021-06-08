//
//  CMPViewController.swift
//  FitnessVideoApp
//
//  Created by Asad on 04/03/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit

class CMPViewController: UIViewController {

    @IBOutlet weak var ddView: UIView!
    @IBOutlet weak var mmView: UIView!
    
    @IBOutlet weak var yyyView: UIView!
    
    @IBOutlet weak var genderView: UIView!
    
    @IBOutlet weak var H1View: UIView!
    
    @IBOutlet weak var H2View: UIView!
    
    @IBOutlet weak var weightView: UIView!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var nametfView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

 nametfView.layer.cornerRadius =  nametfView.bounds.size.height/2
        ddView.layer.cornerRadius =  ddView.bounds.size.height/2
        mmView.layer.cornerRadius =  mmView.bounds.size.height/2

        yyyView.layer.cornerRadius =  yyyView.bounds.size.height/2

        genderView.layer.cornerRadius =  genderView.bounds.size.height/2

        H1View.layer.cornerRadius =  H1View.bounds.size.height/2

        H2View.layer.cornerRadius =  H2View.bounds.size.height/2

        weightView.layer.cornerRadius =  weightView.bounds.size.height/2

        saveBtn.layer.cornerRadius =  saveBtn.bounds.size.height/2


    }
    

    

}
