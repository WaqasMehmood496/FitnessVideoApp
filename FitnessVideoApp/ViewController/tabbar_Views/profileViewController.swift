//
//  profileViewController.swift
//  FitnessVideoApp
//
//  Created by Asad on 04/03/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class profileViewController: UIViewController {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var favouriteCount: UILabel!
    @IBOutlet weak var roundedView: UIView!
    
    //MARK: VARIABLE
    var mAuthFirebase = Auth.auth()
    var ref: DatabaseReference!
    var favoritesArray = [FavoriteModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.roundedView.clipsToBounds = true
        self.roundedView.layer.cornerRadius = 30
        self.roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        profilePic.layer.borderWidth = 1.0
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.white.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2
        profilePic.clipsToBounds = true
        self.assignDataToUI()
        self.getFavoritesFromFirebase()
    }
    
    @IBAction func editBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "ToEditProfile", sender: nil)
    }
    @IBAction func LogoutBtnAction(_ sender: Any) {
        CommonHelper.removeCachedUserData()
        self.changeVC(identifier: "FirstPage")
    }
    
    func assignDataToUI() {
        if let userData = CommonHelper.getCachedUserData() {
            self.userName.text = userData.f_name
            self.phoneNumber.text = userData.mobile_number
            self.userEmail.text = userData.email
            self.password.text = userData.password
        }
    }
    
    // Get All Favorites Videos
    func getFavoritesFromFirebase() {
        if let userID = self.mAuthFirebase.currentUser?.uid{
            ref.child("Favorite").child(userID).observe(.value) { (snapshot) in
                print(snapshot)
                if(snapshot.exists()) {
                    let array:NSArray = snapshot.children.allObjects as NSArray
                    for obj in array {
                        let snapshot:DataSnapshot = obj as! DataSnapshot
                        if let childSnapshot = snapshot.value as? [String : AnyObject]
                        {
                            let favData = FavoriteModel(dic: childSnapshot as NSDictionary)
                            if let blog = favData{
                                self.favoritesArray.append(blog)
                            }
                        }
                    }
                    self.favouriteCount.text = String(self.favoritesArray.count)
                }
            }
        }
    }
    
    func changeVC(identifier:String){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: identifier)
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

//MARK:- WEWBSERVICE EXTENSION
extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
