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
import SDWebImage
import SideMenu
import JGProgressHUD

class profileViewController: UIViewController {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var favouriteCount: UILabel!
    @IBOutlet weak var roundedView: UIView!
    
    //MARK: VARIABLE
    let image = UIImagePickerController()
    var mAuthFirebase = Auth.auth()
    var ref: DatabaseReference!
    var favoritesArray = [FavoriteModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.roundedView.clipsToBounds = true
        self.roundedView.layer.cornerRadius = 30
        self.roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageChangeTarget))
        self.profilePic.addGestureRecognizer(tapGesture)
        profilePic.isUserInteractionEnabled = true
        if let image = CommonHelper.getCachedUserData()?.image {
            profilePic.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "33"))
        }
        profilePic.layer.borderWidth = 1.0
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.white.cgColor
        profilePic.layer.cornerRadius = profilePic.frame.size.width / 2
        profilePic.clipsToBounds = true
        self.assignDataToUI()
        self.getFavoritesFromFirebase()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func editBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "ToEditProfile", sender: nil)
    }
    @IBAction func LogoutBtnAction(_ sender: Any) {
        CommonHelper.removeCachedUserData()
        self.changeVC(identifier: "FirstPage")
    }
    @IBAction func MenuBtnAction(_ sender: Any) {
        let menu = storyboard!.instantiateViewController(withIdentifier: "RightMenu") as! SideMenuNavigationController
        present(menu, animated: true, completion: nil)
    }
    
    
    @objc func imageChangeTarget() {
        openCamera()
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


//MARK:- Firebase Methdos Extension
extension profileViewController {
    // THIS METHOD IS USED FOR UPLOADING IMAGE INTO FIREBASE DATABASE
    func uploadImage(_ image: UIImage){
        if Connectivity.isConnectedToNetwork(){
            showHUDView(hudIV: .indeterminate, text: .process) { (hud) in
                hud.show(in: self.view, animated: true)
                let imageName = UUID().uuidString
                let storageRef = Storage.storage().reference().child("/Profile_Images").child(imageName)
                if let uploadData = image.jpegData(compressionQuality: 0.5){
                    let metaDataForImage = StorageMetadata()
                    metaDataForImage.contentType = "image/jpeg"
                    storageRef.putData(
                        uploadData, metadata: metaDataForImage
                        , completion: { (metadata, error) in
                            if error != nil {
                                print("error")
                                PopupHelper.showAlertControllerWithError(forErrorMessage: "Storage reference not found", forViewController: self)
                                hud.dismiss()
                                return
                            }
                            else{
                                storageRef.downloadURL(completion: { (url, error) in
                                    if error != nil {
                                        PopupHelper.showAlertControllerWithError(forErrorMessage: "Uploading file error", forViewController: self)
                                        hud.dismiss()
                                    }
                                    else{
                                        if let urlText = url?.absoluteString {
                                            self.SaveDatatoDB(imageurl: urlText, hud: hud)
                                        }else{
                                            hud.dismiss()
                                        }
                                    }//End checking error statement
                                })//End downloadURL completion
                            }//End checking error statement
                        })//End storage Ref
                }else{
                    PopupHelper.showAlertControllerWithError(forErrorMessage: "Image compression failed", forViewController: self)
                    hud.dismiss()
                }//End uploadData Statement
            }//End Hud Statement
        }else{
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Internet is unavailable please check your connection", forViewController: self)
        }//End internet connection statement
    }//End Uploading function
    
    //UPDATE IMAGE URL INTO USER TABLE
    func SaveDatatoDB(imageurl:String,hud:JGProgressHUD){
        guard let user = self.mAuthFirebase.currentUser?.uid else {return}
        ref.child("Users").child(user).updateChildValues(["image" : imageurl], withCompletionBlock: { (error, ref) in
            if error != nil{
                if let user = CommonHelper.getCachedUserData() {
                    var userObj = LoginModel()
                    userObj = user
                    userObj.image = imageurl
                    CommonHelper.saveCachedUserData(userObj)
                }
                hud.dismiss()
                return
            }
            else{
                hud.dismiss()
            }
        })
        
        //UPDATE DATA INTO CACHE
        if let userData = CommonHelper.getCachedUserData(){
            userData.image = imageurl
            CommonHelper.saveCachedUserData(userData)
        }
    }
}


//MARK:- CAMERA METHIO'S EXTENSION
extension profileViewController {
    //BOTTOM SHEET WHICH WILL SHOW TWO OPTION [CAMERA AND GALLERY]
    func CameraBottomSheet() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.Selected_choise(choise: "Camera")
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.Selected_choise(choise: "gallery")
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    // THIS METHOD IS USE FOR CHOICE WHICH IS SELECTED BY USER
    func Selected_choise(choise:String){
        if choise == "gallery"{
            self.openGallery()
        }else{
            self.openCamera()
        }
        image.allowsEditing = false
        self.present(image, animated: true)
    }
    //THIS METHODS WILL OPEN GALLERY FOR IMAGE SELECTION
    func openGallery() {
        image.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        image.mediaTypes = ["public.image"]
    }
    // THIS METHOD WILL OPEN CAMERA FOR CAPTURING IMAGE
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else {
            PopupHelper.showAlertControllerWithError(forErrorMessage: "Your device not supporting camera", forViewController: self)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            self.profilePic.image = editedImage
            self.uploadImage(editedImage)
            //isImageUpdate = true
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.profilePic.image = originalImage
            self.uploadImage(originalImage)
            //isImageUpdate = true
        }
        picker.dismiss(animated: true, completion: nil)
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
