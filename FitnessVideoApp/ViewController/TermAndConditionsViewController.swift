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
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func BackBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}

extension TermAndConditionsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TermsCell", for: indexPath) as! TermAndConditionCell
        cell.TermLabel.text = """
 We drafted these Terms of Service (which we call terms) so you’ll know the rules that govern our relationship with you. These terms will be considered a legally binding contract so please read before you sign.

By using Gymclips (aka Dome) you agree that Gymclips is not an exercise program designed to help your child lose weight. Only you are fully responsible for your child’s well-being. You should not allow your child to start these short clips without fully discussing with your family pediatrician. You also agree to waive any attempt to hold Gymclips responsible for any harm doing these movements may bring to your child.

You should not allow your child to do any clips without reviewing the clips for age-appropriate level. Do not leave your children unattended to select the level of exercise they want to do.


1. Who can use these services.
No one under the age of 18 is allowed to create an account. Account must be in name of adult parent only

By using these services, you state that:

    •    You will comply with these terms and conditions
    •    You are not a sex offender
    •    You cannot hold us legally binding for any harm doing these movements

2. Rights we grant you.
Gymclips grants you a personal, worldwide, royalty free, non-assignable, nonexclusive, revocable access to use the services. This access is for the sole purpose of enjoying the services on Gymclips.

    Updates, upgrades and other new features may automatically download. You may be able to adjust these settings thru your device.

    You may not copy, modify or attempt to extract any info from the app.


2. Rights you Grant us:
You agree that Gymclips and our third-party affiliates may place advertising thru out the app.

We love feedback as we see them as an opportunity to improve the APP. We may use them as testimonials without any compensation to you.


3. Privacy
Your privacy is important to us. We will not share your information with any 3rd parties.


 Your Account
You are responsibly for your account. Please use a strong password to keep your account secure. By using the services you agree that

You are monitoring your child’s usage of the app
You will not create a fake account
You will not sell access to your account

If you think someone has gained access to your account, please reach out to support.
"""
        return cell
    }
}
