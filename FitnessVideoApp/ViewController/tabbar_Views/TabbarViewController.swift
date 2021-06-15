//
//  TabbarViewController.swift
//  FitnessVideoApp
//
//  Created by Buzzware Tech on 15/06/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add bar on selected tabbar items
        let tabBar = self.tabBar
        if let barColor = UIColor(named: "BottomBar"){
            tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: barColor, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count)-16, height: tabBar.frame.height), lineWidth: 1.0)
        }
    }
}
