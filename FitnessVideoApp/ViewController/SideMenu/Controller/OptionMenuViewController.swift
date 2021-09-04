//
//  OptionMenuViewController.swift
//  FitnessVideoApp
//
//  Created by Buzzware Tech on 04/09/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit

class OptionMenuViewController: UIViewController {
    
    @IBOutlet weak var SideMenuTableView: UITableView!
    
    let menuArray = [
        "",
        "Terms and Conditions",
        "Privacy Policy",
        "Contact Us",
        "Feedback"
    ]
    
    let menuItemImagesArray = [
        "",
        "18",
        "21",
        "Contact Support",
        "FeedBack"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
}

extension OptionMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogoCell", for: indexPath) as! OptionMenuHeaderTableViewCell
            if let name = CommonHelper.getCachedUserData()?.full_name {
                cell.NameLabel.text = name
            }
            
            if let email = CommonHelper.getCachedUserData()?.email {
                cell.EmailLabel.text = email
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsCell", for: indexPath) as! OptionItemsTableViewCell
            cell.ItemImage.image = UIImage(named: self.menuItemImagesArray[indexPath.row])
            cell.ItemTitle.text = self.menuArray[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let profileModalVC = storyboard.instantiateViewController(withIdentifier: "TermAndCondition") as? TermAndConditionsViewController
            self.navigationController?.pushViewController(profileModalVC!, animated: true)
        } else if indexPath.row == 2{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let profileModalVC = storyboard.instantiateViewController(withIdentifier: "PrivacyPolicy") as? PrivacyPolicyViewController
            self.navigationController?.pushViewController(profileModalVC!, animated: true)
        } else if indexPath.row == 3{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let profileModalVC = storyboard.instantiateViewController(withIdentifier: "FeedbackAndContactUs") as? FeedbackViewController
            profileModalVC?.selectedTitle = "Contact Us"
            self.navigationController?.pushViewController(profileModalVC!, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let profileModalVC = storyboard.instantiateViewController(withIdentifier: "FeedbackAndContactUs") as? FeedbackViewController
            profileModalVC?.selectedTitle = "Feedback"
            self.navigationController?.pushViewController(profileModalVC!, animated: true)
        }
    }
}
