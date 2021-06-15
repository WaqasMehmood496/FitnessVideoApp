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
        if EmailTF.text == nil || EmailTF.text == ""{
            
        }else{
            Auth.auth().sendPasswordReset(withEmail: EmailTF.text!) { error in
                DispatchQueue.main.async {
                    if error != nil {
                        // YOUR ERROR CODE
                        self.ErrorAlertMessage(title: "Alert", description: error!.localizedDescription)
                    } else {
                        //YOUR SUCCESS MESSAGE
                        self.ErrorAlertMessage(title: "Alert", description: "Verification email sended please check your email inbox")
                    }
                }
            }
        }
    }
    
    func ErrorAlertMessage(title:String,description:String) {
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                alert.dismiss(animated: true, completion: nil)
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
