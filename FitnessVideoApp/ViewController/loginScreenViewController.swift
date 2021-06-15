//
//  loginScreenViewController.swift
//  FitnessVideoApp
//
//  Created by Asad on 02/03/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class loginScreenViewController: UIViewController {
    
    //MARK: IBOUTLET'S
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var mobileNumber: UIView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    
    //MARK: VARIABLE'S
    var mAuthFirebase = Auth.auth()
    var ref: DatabaseReference!
    let hud = JGProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.setupUI()
    }
    
    @IBAction func LoginBtnAction(_ sender: Any) {
        guard let email = EmailTF.text else{
            return
        }
        guard let password = PasswordTF.text else {
            return
        }
        signInUser(email: email, password: password)
    }
    @IBAction func BackBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        emailView.layer.cornerRadius =  emailView.bounds.size.height/2
        mobileNumber.layer.cornerRadius =  mobileNumber.bounds.size.height/2
        saveBtn.layer.cornerRadius =  saveBtn.bounds.size.height/2
    }
    
    func signInUser(email:String,password:String){
        if email != "" && password != ""{
            hud.textLabel.text = "Loading"
            hud.show(in: self.view)
            mAuthFirebase.signIn(withEmail: email, password: password) { user, error in
                if let error = error,user == nil{
                    self.hud.dismiss()
                    print(error.localizedDescription)
                    print("SignInFailed")
                }
                else{
                    if let user_FLag = self.mAuthFirebase.currentUser?.isEmailVerified{
                        if user_FLag{
                            
                            if let userID = self.mAuthFirebase.currentUser?.uid{
                                print(userID)
                                self.ref.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                                    print(snapshot)
                                    let value = snapshot.value as? NSDictionary
                                    let user = LoginModel(dic: value as! NSDictionary)
                                    guard let data = user else{return}
                                    CommonHelper.saveCachedUserData(data)
                                    self.hud.dismiss()
                                    self.changeVC(identifier: "Tabbar")
                                    self.hud.dismiss()
                                }){
                                    (error) in
                                    print(error.localizedDescription)
                                    self.hud.dismiss()
                                }
                            }
                            else{
                                PopupHelper.alertWithOk(title: "Login Fail", message: "User not found", controler: self)
                                self.hud.dismiss()
                            }//End auth current user id statement
                        }
                        else{
                            self.ErrorAlertMessage(title: "Email not verifed", description: "Kindly verify your email!")
                        }//End user_Flag statement
                    }
                    else{
                        return
                    }//End isEmailVerified statement
                }//End error nil statement
            }//End auth signin complition
        }//End textfields nil statement
    }//End signin function
    
    func changeVC(identifier:String){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: identifier)
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
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
