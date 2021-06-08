//
//  TermAndConditionsViewController.swift
//  FitnessVideoApp
//
//  Created by Buzzware Tech on 27/05/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit

class TermAndConditionsViewController: UIViewController {
    @IBOutlet weak var TermAndConditionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func BackBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension TermAndConditionsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TermsCell", for: indexPath) as! TermAndConditionCell
        cell.TermLabel.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        return cell
    }
    
    
}
