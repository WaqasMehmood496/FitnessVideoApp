//
//  ForgotPasswordViewController.swift
//  FitnessVideoApp
//
//  Created by Asad on 04/03/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit
import Firebase
class ForgotPasswordViewController: UIViewController {
    //MARK: IBOUTLET'S
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var EmailTF: UITextField!
    
    //MARK: VARIABLE'S
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    
    @IBAction func ResetPasswordBtnAction(_ sender: Any) {
        //if let email = EmailTF.text{
        let email = EmailTF.text!
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error != nil{
                print("Email Sended sucessfully")
            }else{
                print(error)
            }
        }
        //}//end if let email statement
    }
    
}
