//
//  CreateAccountViewController.swift
//  FitnessVideoApp
//
//  Created by Asad on 03/03/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class CreateAccountViewController: UIViewController {
    
    //MARK:IBOUTLET'S
    @IBOutlet weak var FirstNameTF: UITextField!
    @IBOutlet weak var LastNameTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var MoileNumberTF: UITextField!
    @IBOutlet weak var AgreeTermsAndCondition: UIImageView!
    
    //MARK: VARIABLES
    var ref: DatabaseReference!
    var isTermsSelected = false
    var mAuth = Auth.auth()
    let hud = JGProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addingTextfieldsPadding()
        ref = Database.database().reference()
        AddGuestureOnTermBtn()
    }
    
    //MARK: IBACTION'S
    @IBAction func BacBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CreateAccountBtnAction(_ sender: Any) {
        if isTermsSelected{
            self.SignUpUser()
        }else{
            PopupHelper.alertWithOk(title: "Alert", message: "Check the term and condition", controler: self)
        }
    }
    
    // TERMS AND CONDITION TARGET
    @objc func agreeTermAndCondition(_ sender:UITapGestureRecognizer){
        if isTermsSelected{
            self.isTermsSelected = false
            self.AgreeTermsAndCondition.image = UIImage(named: "")
        }else{
            self.isTermsSelected = true
            self.AgreeTermsAndCondition.image = #imageLiteral(resourceName: "icons8-checked-checkbox-50")
        }
    }
}

//MARK:- FUNCTION EXTENSION'S
extension CreateAccountViewController{
    // Add some padding into all text fields from left and right
    func addingTextfieldsPadding() {
        let paddingValue = CGFloat(12)
        
        self.FirstNameTF.setLeftPaddingPoints(paddingValue)
        self.FirstNameTF.setRightPaddingPoints(paddingValue)
        
        self.LastNameTF.setLeftPaddingPoints(paddingValue)
        self.LastNameTF.setRightPaddingPoints(paddingValue)
        
        self.PasswordTF.setLeftPaddingPoints(paddingValue)
        self.PasswordTF.setRightPaddingPoints(paddingValue)
        
        self.EmailTF.setLeftPaddingPoints(paddingValue)
        self.EmailTF.setRightPaddingPoints(paddingValue)
        
        self.MoileNumberTF.setLeftPaddingPoints(paddingValue)
        self.MoileNumberTF.setRightPaddingPoints(paddingValue)
    }
    
    // Add guesture on UIImageview to make it check box
    func AddGuestureOnTermBtn() {
        let tab = UITapGestureRecognizer(target: self, action: #selector(agreeTermAndCondition(_:)))
        AgreeTermsAndCondition.isUserInteractionEnabled = true
        AgreeTermsAndCondition.addGestureRecognizer(tab)
    }
    
    func changeVC(identifier:String){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: identifier)
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func SignUpUser(){
        
        let fname = FirstNameTF.text!
        let lastname = LastNameTF.text!
        let password = PasswordTF.text!
        let email = EmailTF.text!
        let mobilenumber = MoileNumberTF.text!
        
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        if email != "" && fname != "" && lastname != "" && mobilenumber != ""
        {
            
            mAuth.createUser(withEmail: email, password: password) { result, err in
                if let error = err {
                    print(error)
                    let alert = UIAlertController(title: "Alert", message: "Email Already Exist", preferredStyle: .alert)
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
                    self.hud.dismiss(afterDelay: 0.0)
                }
                else{
                    self.mAuth.currentUser?.sendEmailVerification(completion: { err in
                        if let error = err{
                            print(error)
                            self.hud.dismiss(afterDelay: 3.0)
                        }
                        else{
                            self.insertUsertoDataBase(fname: fname, lname: lastname, lastname: "\(fname) \(lastname)", password: password, mobilenumber: mobilenumber, imageURL: "", email: email)
                            self.hud.dismiss(afterDelay: 3.0)
                            let alert = UIAlertController(title: "Verification email Sent", message: "Verify your email.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                                switch action.style{
                                case .default:
                                    self.changeVC(identifier: "Tabbar")
                                case .cancel:
                                    print("cancel")
                                case .destructive:
                                    print("destructive")
                                }
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
    }
    
    func insertUsertoDataBase(fname:String,lname:String,lastname:String,password:String,mobilenumber:String,imageURL:String,email:String){
        guard let user = mAuth.currentUser?.uid else {
            return
        }
        self.ref.child("Users").child(user).setValue([
            "age":"",
            "email":email,
            "f_name":fname,
            "full_name":"\(fname) \(lastname)",
            "gender":"",
            "height":"",
            "l_name":lastname,
            "mobile_number":mobilenumber,
            "password":password,
            "weight":""
        ])
        
        let currentuser = LoginModel(age: "", email: email, f_name: fname, full_name: "\(fname) \(lastname)", gender: "", height: "", l_name: lastname, mobile_number: mobilenumber, password: password, weight: "")
        CommonHelper.saveCachedUserData(currentuser)
    }
    
}
