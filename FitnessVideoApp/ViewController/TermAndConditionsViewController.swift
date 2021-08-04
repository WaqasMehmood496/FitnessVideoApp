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
        return cell
    }
}
