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
    // Getting all video from server
    func VideosApiCall() {
        self.dataDic = [String:Any]()
        let hud = JGProgressHUD()
        self.getLoginWebservice(.myvideoslist, hud: hud)
    }
    
    // Get All Favorites Videos
    func getFavoritesFromFirebase() {
        let hud = JGProgressHUD()
        hud.show(in: self.view)
        if let userID = self.mAuthFirebase.currentUser?.uid{
            ref.child("Favorite").child(userID).observe(.value) { (snapshot) in
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
                    DispatchQueue.main.async {
                        self.basicCollectionView.reloadData()
                        self.interCV.reloadData()
                        self.adv_CollectionView.reloadData()
                    }
                    
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
        if let userID = self.mAuthFirebase.currentUser?.uid{
            ref.child("Favorite").child(userID).observe(.value) { (snapshot) in
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
                completionHandler(false)
                hud.dismiss()
            }// End ref Child Completion Block
            completionHandler(false)
        }// End Firebase user id
        else{
            hud.dismiss()
        }
        completionHandler(false)
    }// End get favorite method
    
    func checkIsFavorite(video:VideoTypeModel) -> Bool {
        for i in self.favoritesArray{
            if i.title == video.title{
                
                return true
            }
        }
        return false
    }
    
    func returnFavoriteVideoId(video:VideoTypeModel) -> String? {
        for i in self.favoritesArray{
            if i.title == video.title{
                return i.id
            }
        }
        return nil
    }
    
    
    func addIntoFavorite(name:String,title:String,url:String){
        guard let user = mAuthFirebase.currentUser?.uid else {
            return
        }
        self.ref.child("Favorite").child(user).childByAutoId().setValue([
            "name":name,
            "title":title,
            "url":url
        ])
    }
    
    func deleteFavorite(id:String) {
        guard let user = mAuthFirebase.currentUser?.uid else {
            return
        }
        print(user)
        self.ref.child("Favorite").child(user).child(id).removeValue { (error, _ in) in
            print(error)
        }
    }
    
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
                //self.videos.basic[indexPath.row].isFavorite = true
                cell.favouritesBtn.setImage(#imageLiteral(resourceName: "Fill_Heart"), for: .normal)
            }else{
                self.videos.basic[indexPath.row].isFavorite = false
                //cell.favouritesBtn.setImage(#imageLiteral(resourceName: "4"), for: .normal)
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
               // self.videos.intermediate[indexPath.row].isFavorite = false
                cell.favBtn.setImage(#imageLiteral(resourceName: "4"), for: .normal)
            }else{
                self.videos.intermediate[indexPath.row].isFavorite = true
                //cell.favBtn.setImage(#imageLiteral(resourceName: "Fill_Heart"), for: .normal)
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
                //self.videos.advance[indexPath.row].isFavorite = true
                cell.favBtn.setImage(#imageLiteral(resourceName: "Fill_Heart"), for: .normal)
            }else{
                //self.videos.advance[indexPath.row].isFavorite = false
                cell.favBtn.setImage(#imageLiteral(resourceName: "4"), for: .normal)
            }
            cell.favBtn.addTarget(self, action: #selector(favouritesAdvanceBtn(_:)), for: .touchUpInside)
            cell.favBtn.tag = indexPath.row
            cell.playBtn.addTarget(self, action: #selector(playAdvanceBtn(_:)), for: .touchUpInside)
            cell.playBtn.tag = indexPath.row
            return cell
        }
    }
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//       
//    }
    
    
    
    
    //MARK: Favorite Btn Action
    @objc func favouritesBasicBtn( _ sender:UIButton){
        if self.videos.basic[sender.tag].isFavorite{
            //TAGS: DELETE FORM FAVORITE
            // change btn image
            sender.setImage(#imageLiteral(resourceName: "4"), for: .normal)
            // change basic video favorite status
            self.videos.basic[sender.tag].isFavorite = false
            // get all favorite from firebase
            self.refreshFavorite { (isUpdated) in
                if isUpdated == true{
                    if let id = self.returnFavoriteVideoId(video: self.videos.basic[sender.tag]){
                        print(id)
                        self.deleteFavorite(id: id)
                        
                    }
                }
            }
        }else{
            // ADD INTO FAVORITE
            sender.setImage(#imageLiteral(resourceName: "Fill_Heart"), for: .normal)
            self.videos.basic[sender.tag].isFavorite = true
            self.addIntoFavorite(name: "Basic \(sender.tag)", title: self.videos.basic[sender.tag].title, url: self.videos.basic[sender.tag].urls)
        }
    }
    
    
    
    
    //MARK: Favorite Btn Action
    @objc func favouritesInterediateBtn( _ sender:UIButton){
        if self.videos.intermediate[sender.tag].isFavorite{
//            // DELETE FORM FAVORITE
//            sender.setImage(#imageLiteral(resourceName: "4"), for: .normal)
//            self.videos.intermediate[sender.tag].isFavorite = false
//            if let id = returnFavoriteVideoId(video: self.videos.intermediate[sender.tag]){
//                self.deleteFavorite(id: id)
//            }
            
            //TAGS: DELETE FORM FAVORITE
            // change btn image
            sender.setImage(#imageLiteral(resourceName: "4"), for: .normal)
            // change basic video favorite status
            self.videos.intermediate[sender.tag].isFavorite = false
            // get all favorite from firebase
            self.refreshFavorite { (isUpdated) in
                if isUpdated{
                    if let id = self.returnFavoriteVideoId(video: self.videos.intermediate[sender.tag]){
                        print(id)
                        self.deleteFavorite(id: id)
                    }
                }
            }
        }else{
            // ADD INTO FAVORITE
            sender.setImage(#imageLiteral(resourceName: "Fill_Heart"), for: .normal)
            self.videos.intermediate[sender.tag].isFavorite = true
            self.addIntoFavorite(name: "Intermediate \(sender.tag)", title: self.videos.intermediate[sender.tag].title, url: self.videos.intermediate[sender.tag].urls)
        }
    }
    
    //MARK: Favorite Btn Action
    @objc func favouritesAdvanceBtn( _ sender:UIButton){
        if self.videos.advance[sender.tag].isFavorite{
//            // DELETE FORM FAVORITE
//            sender.setImage(#imageLiteral(resourceName: "4"), for: .normal)
//            self.videos.advance[sender.tag].isFavorite = false
//            if let id = returnFavoriteVideoId(video: self.videos.advance[sender.tag]){
//                self.deleteFavorite(id: id)
//            }
            
            //TAGS: DELETE FORM FAVORITE
            // change btn image
            //sender.setImage(#imageLiteral(resourceName: "4"), for: .normal)
            self.basicCollectionView.reloadData()
            // change basic video favorite status
            self.videos.advance[sender.tag].isFavorite = false
            // get all favorite from firebase
            self.refreshFavorite { (isUpdated) in
                if isUpdated{
                    if let id = self.returnFavoriteVideoId(video: self.videos.advance[sender.tag]){
                        print(id)
                        self.deleteFavorite(id: id)
                    }
                }
            }
        }else{
            // ADD INTO FAVORITE
            //sender.setImage(#imageLiteral(resourceName: "Fill_Heart"), for: .normal)
            self.basicCollectionView.reloadData()
            self.videos.advance[sender.tag].isFavorite = true
            self.addIntoFavorite(name: "Advance \(sender.tag)", title: self.videos.advance[sender.tag].title, url: self.videos.advance[sender.tag].urls)
        }
    }
    
    // Play Btn Action
    @objc func playBasicBtn( _ sender:UIButton){
//        if collectionView == self.basicCollectionView{
//            self.selectedType = 0
//        }else if collectionView == self.interCV {
//            self.selectedType = 1
//        }else{
//            self.selectedType = 2
//        }
//        self.selectedVideo = indexPath
//        self.performSegue(withIdentifier: "PlayerVC", sender: nil)
    }
    @objc func playIntermediateBtn( _ sender:UIButton){
        
    }
    @objc func playAdvanceBtn( _ sender:UIButton){
        
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
            self.getFavoritesFromFirebase()
            hud.dismiss(animated: true)
        }else{
            hud.textLabel.text = "Data Not Found"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2, animated: true)
        }
    }
}
