//
//  EditProfileViewController.swift
//  FitnessVideoApp
//
//  Created by Buzzware Tech on 02/06/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit
import DLRadioButton
import Firebase
import JGProgressHUD

class EditProfileViewController: UIViewController {
    
    //MARK:IBOUTLET'S
    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var MonthTF: UITextField!
    @IBOutlet weak var DayTF: UITextField!
    @IBOutlet weak var YearTF: UITextField!
    @IBOutlet weak var HeightTF: UITextField!
    @IBOutlet weak var WeightTF: UITextField!
    @IBOutlet weak var MaleBtn: DLRadioButton!
    @IBOutlet weak var FemaleBtn: DLRadioButton!
    //MARK:VARIABLE'S
    var ref: DatabaseReference!
    var mAuth = Auth.auth()
    let hud = JGProgressHUD()
    var gender = "male"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        MaleBtn.isSelected = true
        ref = Database.database().reference()
    }
    //MARK:IBACTION'S
    @IBAction func MaleBtnAction(_ sender: DLRadioButton) {
        FemaleBtn.isSelected = false
        MaleBtn.isSelected = true
        self.gender = "male"
    }
    @IBAction func FemaleBtnAction(_ sender: DLRadioButton) {
        MaleBtn.isSelected = false
        FemaleBtn.isSelected = true
        self.gender = "female"
    }
    @IBAction func UpdateBtnAction(_ sender: Any) {
        self.updatefields()
    }
    
    
}


//MARK:- FUNCTION EXTENSION
extension EditProfileViewController{
    func setupUI() {
        self.NameTF.setLeftPaddingPoints(8)
        self.NameTF.setRightPaddingPoints(8)
        
        self.DayTF.setLeftPaddingPoints(8)
        self.DayTF.setRightPaddingPoints(8)
        
        self.MonthTF.setLeftPaddingPoints(8)
        self.MonthTF.setRightPaddingPoints(8)
        
        self.YearTF.setLeftPaddingPoints(8)
        self.YearTF.setRightPaddingPoints(8)
        
        self.HeightTF.setLeftPaddingPoints(8)
        self.HeightTF.setRightPaddingPoints(8)
        
        self.WeightTF.setLeftPaddingPoints(8)
        self.WeightTF.setRightPaddingPoints(8)
        
    }
    
    func updatefields(){
        
        guard let userId = self.mAuth.currentUser?.uid else {
            return
        }
        guard let userData = CommonHelper.getCachedUserData() else {
            return
        }
        
        let name = NameTF.text!
        let month = MonthTF.text!
        let day = DayTF.text!
        let year = YearTF.text!
        let height = HeightTF.text!
        let weight = WeightTF.text!
        
        self.ref.child("Users").child(userId).updateChildValues([
            "age":"\(month)-\(day)-\(year)",
            "email":userData.email,
            "f_name":userData.f_name,
            "full_name":name,
            "gender":gender,
            "height":height,
            "l_name":userData.l_name,
            "mobile_number":userData.mobile_number,
            "password":userData.password,
            "weight":weight
        ], withCompletionBlock: { (error, ref) in
            if error != nil{
                self.hud.dismiss()
                return
            }
            else{
                self.hud.dismiss()
                PopupHelper.alertWithOk(title: "Success", message: "Record updated successfully", controler: self)
            }
        })
    }
}
