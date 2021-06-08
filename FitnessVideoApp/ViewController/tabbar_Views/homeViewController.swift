//
//  homeViewController.swift
//  FitnessVideoApp
//
//  Created by Asad on 03/03/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit
import JGProgressHUD
import AVKit
import SDWebImage
import Firebase

class homeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    //MARK: IBOUTLET'S
    @IBOutlet weak var basicCollectionView: UICollectionView!
    @IBOutlet weak var interCV: UICollectionView!
    @IBOutlet weak var adv_CollectionView: UICollectionView!
    //MARK: VARIABLE'S
    var dataDic = [String:Any]()
    var videos = VideoModel()
    var firstLoad = false
    let basic = ["aa1","aa2","aa3","aa4"]
    let intermediate = ["aa5"]
    let advance = ["aa6","aa7","aa8","aa9","aa10"]
    var selectedType = 0
    var selectedVideo = IndexPath()
    var mAuthFirebase = Auth.auth()
    var ref: DatabaseReference!
    var favoritesArray = [FavoriteModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.navigationItem.title = "Home"
        self.VideosApiCall()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayerVC" {
            if let playerVC = segue.destination as? intermVideoViewController {
                if self.selectedType == 0{
                    if let basic = self.videos.basic {
                        playerVC.videos = basic
                    }
                }else if self.selectedType == 1{
                    if let intermediate = self.videos.intermediate {
                        playerVC.videos = intermediate
                    }
                }else{
                    if let advance = self.videos.advance {
                        playerVC.videos = advance
                    }
                }
                playerVC.thumbnail = 0
                playerVC.selectedType = self.selectedType
                playerVC.selectedVideo = self.selectedVideo
            }
        }
    }
}

//MARK:- FUNCTIONS EXTENSION
extension homeViewController{
    
    // GETT ALL VIDEOS FROM SERVER
    func VideosApiCall() {
        self.dataDic = [String:Any]()
        let hud = JGProgressHUD()
        self.getLoginWebservice(.myvideoslist, hud: hud)
    }
    
    // GET ALL FAVORITES VIDEOS FROM FIREBASE DATABASE
    func getFavoritesFromFirebase() {
        let hud = JGProgressHUD()
        hud.show(in: self.view)
        self.favoritesArray.removeAll()
        if let userID = self.mAuthFirebase.currentUser?.uid{
            ref.child("Favorite").child(userID).observeSingleEvent(of: .value) { (snapshot) in
                print(snapshot)
                if(snapshot.exists()) {
                    let array:NSArray = snapshot.children.allObjects as NSArray
                    for obj in array {
                        let snapshot:DataSnapshot = obj as! DataSnapshot
                        if var childSnapshot = snapshot.value as? [String : AnyObject]
                        {
                            childSnapshot[Constant.id] = snapshot.key as String as AnyObject
                            let favData = FavoriteModel(dic: childSnapshot as NSDictionary)
                            if let fav = favData{
                                self.favoritesArray.append(fav)
                            }
                        }
                    }// End For loop
                    hud.dismiss()
                }// End Snapshot if else statement
                self.basicCollectionView.reloadData()
                self.interCV.reloadData()
                self.adv_CollectionView.reloadData()
                hud.dismiss()
            }// End ref Child Completion Block
        }// End Firebase user id
        else{
            hud.dismiss()
        }
    }// End get favorite method
    
    
    // Update All Favorites
    func refreshFavorite(completionHandler: @escaping (Bool) -> Void) {
        let hud = JGProgressHUD()
        hud.show(in: self.view)
        self.favoritesArray.removeAll()
        if let userID = self.mAuthFirebase.currentUser?.uid{
            ref.child("Favorite").child(userID).observeSingleEvent(of: .value) { (snapshot) in
                print(snapshot)
                if(snapshot.exists()) {
                    let array:NSArray = snapshot.children.allObjects as NSArray
                    for obj in array {
                        let snapshot:DataSnapshot = obj as! DataSnapshot
                        if var childSnapshot = snapshot.value as? [String : AnyObject]
                        {
                            childSnapshot[Constant.id] = snapshot.key as String as AnyObject
                            let favData = FavoriteModel(dic: childSnapshot as NSDictionary)
                            if let fav = favData{
                                self.favoritesArray.append(fav)
                            }
                        }
                    }// End For loop
                    completionHandler(true)
                    hud.dismiss()
                }// End Snapshot if else statement
                else{
                    completionHandler(true)
                    hud.dismiss()
                }
            }// End ref Child Completion Block
        }// End Firebase user id
        else{
            hud.dismiss()
            completionHandler(false)
        }
        
    }// End get favorite method
    
    // THIS METHOD CHECK THAT GIVEN VIDEO IS FAVORITE OR NOT , IF IT IS FAVORITE THEN RETURN TRUE ELSE RETURN FALSE
    func checkIsFavorite(video:VideoTypeModel) -> Bool {
        for i in self.favoritesArray{
            if i.title == video.title{
                return true
            }
        }
        return false
    }
    // THIS METHOD WILL REMOVE FAVORITE VIDEO FROM FIREBASE DATABASE
    func removeFromFavorites(video:VideoTypeModel, completionHandler: @escaping (Bool) -> Void) {
        var userId = String()
        for i in self.favoritesArray{
            if i.title == video.title{
                userId = i.id
            }
        }
        
        if let user = mAuthFirebase.currentUser?.uid{
            self.ref.child("Favorite").child(user).child(userId).removeValue { (error, _ in) in
                if error == nil{
                    completionHandler(true)
                }else{
                    print(error!.localizedDescription)
                }
            }
        }else{
            completionHandler(false)
        }
    }
    
    // THIS METHOD WILL SAVE OR ADD NEW VIDEO IN FIREBASE FAVORITE DATABASE
    func addIntoFavorite(name:String,title:String,url:String){
        guard let user = mAuthFirebase.currentUser?.uid else {
            return
        }
        self.ref.child("Favorite").child(user).childByAutoId().setValue([
            "name":name,
            "title":title,
            "url":url
        ])
    }// End Add in to favorites method
}

//MARK:- UICOLLECTION VIEW
extension homeViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if firstLoad{
            if collectionView == self.basicCollectionView{
                return self.videos.basic.count
            }
            else if collectionView == self.interCV {
                return self.videos.intermediate.count
            }
            else{
                return self.videos.advance.count
            }
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.basicCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "basicCell", for: indexPath) as! HomeCollectionViewCell
            if indexPath.row > self.basic.count{
                cell.mainImage.image = #imageLiteral(resourceName: "8")
            }else{
                cell.mainImage.image = UIImage(named: self.basic[indexPath.row])
            }
            if checkIsFavorite(video: self.videos.basic[indexPath.row]){
                cell.favouritesBtn.setImage(#imageLiteral(resourceName: "Fill_Heart"), for: .normal)
            }else{
                cell.favouritesBtn.setImage(#imageLiteral(resourceName: "4"), for: .normal)
            }
            
            cell.favouritesBtn.addTarget(self, action: #selector(favouritesBasicBtn(_:)), for: .touchUpInside)
            cell.favouritesBtn.tag = indexPath.row
            cell.playBtn.addTarget(self, action: #selector(playBasicBtn(_:)), for: .touchUpInside)
            cell.playBtn.tag = indexPath.row
            return cell
        }
        else if collectionView == self.interCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "intermCell", for: indexPath) as! interViewCollectionViewCell
            if indexPath.row > self.intermediate.count{
                cell.mainImage.image = #imageLiteral(resourceName: "8")
            }else{
                cell.mainImage.image = UIImage(named: self.intermediate[indexPath.row])
            }
            if checkIsFavorite(video: self.videos.intermediate[indexPath.row]){
                cell.favBtn.setImage(#imageLiteral(resourceName: "4"), for: .normal)
            }else{
                self.videos.intermediate[indexPath.row].isFavorite = true
            }
            cell.favBtn.addTarget(self, action: #selector(favouritesInterediateBtn(_:)), for: .touchUpInside)
            cell.favBtn.tag = indexPath.row
            cell.playBtn.addTarget(self, action: #selector(playIntermediateBtn(_:)), for: .touchUpInside)
            cell.playBtn.tag = indexPath.row
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvanceCell", for: indexPath) as! advanceCollectionViewCell
            if indexPath.row > self.advance.count{
                cell.mainImage.image = #imageLiteral(resourceName: "8")
            }else{
                cell.mainImage.image = UIImage(named: self.advance[indexPath.row])
            }
            if checkIsFavorite(video: self.videos.advance[indexPath.row]){
                cell.favBtn.setImage(#imageLiteral(resourceName: "Fill_Heart"), for: .normal)
            }else{
                cell.favBtn.setImage(#imageLiteral(resourceName: "4"), for: .normal)
            }
            cell.favBtn.addTarget(self, action: #selector(favouritesAdvanceBtn(_:)), for: .touchUpInside)
            cell.favBtn.tag = indexPath.row
            cell.playBtn.addTarget(self, action: #selector(playAdvanceBtn(_:)), for: .touchUpInside)
            cell.playBtn.tag = indexPath.row
            return cell
        }
    }
    
    //MARK: Favorite Btn Action
    @objc func favouritesBasicBtn( _ sender:UIButton){
        // RELOAD ALL FAVORITES FROM FIREBASE
        self.refreshFavorite { (isRefresh) in
            if isRefresh == true{
                // CHECK IS EXIST IN FAVORITE
                if self.checkIsFavorite(video: self.videos.basic[sender.tag]){
                    // IF IT IS, THEN REMOVE FROM FAVORITE AND CHANGE IMAGE AS EMPTY HEART
                    self.removeFromFavorites(video: self.videos.basic[sender.tag]) { (isRemoved) in
                        if isRemoved{
                            sender.setImage(#imageLiteral(resourceName: "4"), for: .normal)
                        }else{
                            sender.setImage(#imageLiteral(resourceName: "Fill_Heart"), for: .normal)
                        }
                    }
                }else{
                    // ELSE ADD INTO FAVORITE AND CHANGE IMAGE AS FILL HEART
                    self.addIntoFavorite(name: "Basic \(sender.tag)", title: self.videos.basic[sender.tag].title, url: self.videos.basic[sender.tag].urls)
                    sender.setImage(#imageLiteral(resourceName: "Fill_Heart"), for: .normal)
                }
            }else{
                // SHOW ALERT
                PopupHelper.alertWithOk(title: "Fail", message: "Unknown error found", controler: self)
            }
        }
    }
    
    
    //MARK: Favorite Btn Action
    @objc func favouritesInterediateBtn( _ sender:UIButton){
        // RELOAD ALL FAVORITES FROM FIREBASE
        self.refreshFavorite { (isRefresh) in
            if isRefresh == true{
                // CHECK IS EXIST IN FAVORITE
                if self.checkIsFavorite(video: self.videos.intermediate[sender.tag]){
                    // IF IT IS, THEN REMOVE FROM FAVORITE AND CHANGE IMAGE AS EMPTY HEART
                    self.removeFromFavorites(video: self.videos.intermediate[sender.tag]) { (isRemoved) in
                        if isRemoved{
                            sender.setImage(#imageLiteral(resourceName: "4"), for: .normal)
                        }else{
                            sender.setImage(#imageLiteral(resourceName: "Fill_Heart"), for: .normal)
                        }
                    }
                }else{
                    // ELSE ADD INTO FAVORITE AND CHANGE IMAGE AS FILL HEART
                    self.addIntoFavorite(name: "Basic \(sender.tag)", title: self.videos.intermediate[sender.tag].title, url: self.videos.intermediate[sender.tag].urls)
                    sender.setImage(#imageLiteral(resourceName: "Fill_Heart"), for: .normal)
                }
            }else{
                // SHOW ALERT
                PopupHelper.alertWithOk(title: "Fail", message: "Unknown error found", controler: self)
            }
        }
    }
    
    //MARK: Favorite Btn Action
    @objc func favouritesAdvanceBtn( _ sender:UIButton){
        // RELOAD ALL FAVORITES FROM FIREBASE
        self.refreshFavorite { (isRefresh) in
            if isRefresh == true{
                // CHECK IS EXIST IN FAVORITE
                if self.checkIsFavorite(video: self.videos.advance[sender.tag]){
                    // IF IT IS, THEN REMOVE FROM FAVORITE AND CHANGE IMAGE AS EMPTY HEART
                    self.removeFromFavorites(video: self.videos.advance[sender.tag]) { (isRemoved) in
                        if isRemoved{
                            sender.setImage(#imageLiteral(resourceName: "4"), for: .normal)
                        }else{
                            sender.setImage(#imageLiteral(resourceName: "Fill_Heart"), for: .normal)
                        }
                    }
                }else{
                    // ELSE ADD INTO FAVORITE AND CHANGE IMAGE AS FILL HEART
                    self.addIntoFavorite(name: "Basic \(sender.tag)", title: self.videos.advance[sender.tag].title, url: self.videos.advance[sender.tag].urls)
                    sender.setImage(#imageLiteral(resourceName: "Fill_Heart"), for: .normal)
                }
            }else{
                // SHOW ALERT
                PopupHelper.alertWithOk(title: "Fail", message: "Unknown error found", controler: self)
            }
        }
    }
    
    //MARK: Play Btn Action
    @objc func playBasicBtn( _ sender:UIButton){
        self.selectedType = 0
        self.selectedVideo = IndexPath(row: sender.tag, section: 0)
        self.performSegue(withIdentifier: "PlayerVC", sender: nil)
    }
    @objc func playIntermediateBtn( _ sender:UIButton){
        self.selectedType = 1
        self.selectedVideo = IndexPath(row: sender.tag, section: 0)
        self.performSegue(withIdentifier: "PlayerVC", sender: nil)
    }
    @objc func playAdvanceBtn( _ sender:UIButton){
        self.selectedType = 2
        self.selectedVideo = IndexPath(row: sender.tag, section: 0)
        self.performSegue(withIdentifier: "PlayerVC", sender: nil)
    }
}

//MARK:- WEWBSERVICE EXTENSION
extension homeViewController:WebServiceResponseDelegate{
    func getLoginWebservice(_ urltype:webserviceUrl, hud: JGProgressHUD){
        let helper = WebServicesHelper(serviceToCall: urltype, withMethod: .post, havingParameters: self.dataDic, relatedViewController: self,hud: hud)
        helper.delegateForWebServiceResponse = self
        helper.callWebService()
    }
    func webServiceDataParsingOnResponseReceived(url: webserviceUrl?, viewControllerObj: UIViewController?, dataDict: Any, hud: JGProgressHUD) {
        if let data = dataDict as? Dictionary<String, Any>{
            print(data)
            
            self.videos = VideoModel(dic: data as NSDictionary)!
            for _ in 0...1{
                for basic in self.videos.basic{
                    basic.isFavorite = false
                }
                for intermediate in self.videos.intermediate{
                    intermediate.isFavorite = false
                }
                for advance in self.videos.advance{
                    advance.isFavorite = false
                }
            }
            self.firstLoad = true
            self.basicCollectionView.reloadData()
            self.interCV.reloadData()
            self.adv_CollectionView.reloadData()
            self.getFavoritesFromFirebase()
            hud.dismiss(animated: true)
        }else{
            hud.textLabel.text = "Data Not Found"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2, animated: true)
        }
    }
}
