//
//  TestMenuViewController.swift
//  FitnessVideoApp
//
//  Created by Buzzware Tech on 04/09/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit
import SideMenu
class TestMenuViewController: UIViewController {

    @IBOutlet weak var MenuBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func SideMenuBtnAction(_ sender: Any) {
        
        // SideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
         let menu = storyboard!.instantiateViewController(withIdentifier: "RightMenu") as! SideMenuNavigationController
//        let menu = SideMenuNavigationController(rootViewController: menu)
        present(menu, animated: true, completion: nil)
    }
    
}
