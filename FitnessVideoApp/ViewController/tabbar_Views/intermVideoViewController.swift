//
//  intermVideoViewController.swift
//  FitnessVideoApp
//
//  Created by Asad on 04/03/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit
import VersaPlayer
import JGProgressHUD
import Firebase

class intermVideoViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, VersaPlayerPlaybackDelegate {
    //MARK: IBOUTLET'S
    @IBOutlet weak var interVideoCollectionView: UICollectionView!
    @IBOutlet weak var PlayerView: VersaPlayerView!
    @IBOutlet weak var controls: VersaPlayerControls!
    @IBOutlet weak var VideoTitle: UILabel!
    @IBOutlet weak var CreatedTime: UILabel!
    
    //MARK: VARIABLE'S
    var videos = [VideoTypeModel]()
    var favoriteVideos = [FavoriteModel]()
    var mAuthFirebase = Auth.auth()
    var ref: DatabaseReference!
    var thumbnail = 0
    var selectedType = 0
    let basic = ["aa1","aa2","aa3","aa4"]
    let intermediate = ["aa5"]
    let advance = ["aa6","aa7","aa8","aa9","aa10"]
    var selectedVideo = IndexPath()
    var isFavorite = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.getFavoritesFromFirebase()
        self.playVideo()
    }
}


// MARK:- FUNCTION'S EXTENSION
extension intermVideoViewController{
    // Play selected Video
    func playVideo() {
        if isFavorite{
            player(url: self.favoriteVideos[selectedVideo.row].url)
            self.VideoTitle.text = self.favoriteVideos[selectedVideo.row].title
            self.CreatedTime.text = "2 hours"
        }else{
            player(url:  self.videos[selectedVideo.row].urls)
            self.VideoTitle.text = self.videos[selectedVideo.row].title
            self.CreatedTime.text = "2 hours"
        }
    }
    
    func player(url:String) {
        if let url = URL.init(string: url) {
            let item = VersaPlayerItem(url: url)
            PlayerView.playbackDelegate = self
            PlayerView.layer.backgroundColor = UIColor.black.cgColor
            PlayerView.use(controls: controls)
            PlayerView.set(item: item)
        }
    }
    
    func removePlayer(url:String) {
        if let url = URL.init(string: url) {
            let item = VersaPlayerItem(url: url)
            self.PlayerView.player.replaceCurrentItem(with: item)
        }
    }
    
    func checkType(video:FavoriteModel) -> String {
        let firstChar = video.name.first
        let strArray = video.name.components(separatedBy: " ")
        let lstValue = Int(strArray.last!)!
        if firstChar == "B"{
            return self.basic[lstValue]
        }else if firstChar == "I"{
            return self.intermediate[lstValue]
        }else{
            return self.advance[lstValue]
        }
    }
    
    // Get All Favorites Videos
    func getFavoritesFromFirebase() {
        let hud = JGProgressHUD()
        hud.show(in: self.view)
        self.favoriteVideos.removeAll()
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
                                self.favoriteVideos.append(fav)
                            }
                        }
                    }// End For loop
                    hud.dismiss()
                }// End Snapshot if else statement
                self.interVideoCollectionView.reloadData()
                hud.dismiss()
            }// End ref Child Completion Block
        }// End Firebase user id
        else{
            hud.dismiss()
        }
    }// End get favorite method
    
    func refreshFavorite(completionHandler: @escaping (Bool) -> Void) {
        let hud = JGProgressHUD()
        hud.show(in: self.view)
        self.favoriteVideos.removeAll()
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
                                self.favoriteVideos.append(fav)
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
        
    }// End get
    
    
    // THIS METHOD CHECK THAT GIVEN VIDEO IS FAVORITE OR NOT , IF IT IS FAVORITE THEN RETURN TRUE ELSE RETURN FALSE
    func checkIsFavorite(video:VideoTypeModel) -> Bool {
        for i in self.favoriteVideos{
            if i.title == video.title{
                return true
            }
        }
        return false
    }
    
    // THIS METHOD WILL REMOVE SELECTED VIDEO FROM FIREBASE DATABASE
    func removeFromFavorites(video:VideoTypeModel, completionHandler: @escaping (Bool) -> Void) {
        var userId = String()
        for i in self.favoriteVideos{
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
    
    // THIS METHOD WILL INSERT SELECTED VIDEO INTO FAVORITE TABLE OF FIREBASE DATABASE
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
}


//MARK:- UICOLLECTION VIEW DELEGATES AND DATASOURCE
extension intermVideoViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFavorite{
            return favoriteVideos.count
        }else{
            return self.videos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! interVCCollectionViewCell
        
        if isFavorite{
            let image = self.checkType(video: self.favoriteVideos[indexPath.row])
            cell.mainImage.image = UIImage(named: image)
            cell.mainLBL.text = self.favoriteVideos[indexPath.row].title
            
        }else{
            if selectedType == 0{
                cell.mainImage.image = UIImage(named: self.basic[indexPath.row])
                cell.mainLBL.text = self.videos[indexPath.row].title
            }else if selectedType == 1{
                cell.mainImage.image = UIImage(named: self.intermediate[indexPath.row])
                cell.mainLBL.text = self.videos[indexPath.row].title
            }else{
                cell.mainImage.image = UIImage(named: self.advance[indexPath.row])
                cell.mainLBL.text = self.videos[indexPath.row].title
            }
            // CHANGE FAVORITE BUTTON IMAGE
            if checkIsFavorite(video: self.videos[indexPath.row]){
                cell.favBtn.setImage(#imageLiteral(resourceName: "Fill_Heart"), for: .normal)
            }else{
                cell.favBtn.setImage(#imageLiteral(resourceName: "4"), for: .normal)
            }
            cell.playBtn.addTarget(self, action: #selector(playBtnAction(_:)), for: .touchUpInside)
            cell.favBtn.addTarget(self, action: #selector(favoriteBtnAction(_:)), for: .touchUpInside)
            cell.favBtn.tag = indexPath.row
        }// END isFavorite Statements
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFavorite{
            self.removePlayer(url: self.favoriteVideos[indexPath.row].url)
        }else{
            self.removePlayer(url: self.videos[indexPath.row].urls)
        }
    }
    
    @objc func playBtnAction(_ sender: UIButton) {
        if isFavorite{
            
        }else{
            if selectedType == 0{
                
            }else if selectedType == 1{
                
            }else{
                
            }
        }
    }
    
    @objc func favoriteBtnAction(_ sender: UIButton) {
        if isFavorite{
            
        }else{
            // RELOAD ALL FAVORITES FROM FIREBASE
            self.refreshFavorite { (isRefresh) in
                if isRefresh == true{
                    // CHECK IS EXIST IN FAVORITE
                    if self.checkIsFavorite(video: self.videos[sender.tag]){
                        // IF IT IS, THEN REMOVE FROM FAVORITE AND CHANGE IMAGE AS EMPTY HEART
                        self.removeFromFavorites(video: self.videos[sender.tag]) { (isRemoved) in
                            if isRemoved{
                                sender.setImage(#imageLiteral(resourceName: "4"), for: .normal)
                            }else{
                                sender.setImage(#imageLiteral(resourceName: "Fill_Heart"), for: .normal)
                            }
                        }
                    }else{
                        if self.selectedType == 0{
                            self.addIntoFavorite(name: "Basic \(sender.tag)", title: self.videos[sender.tag].title, url: self.videos[sender.tag].urls)
                        }else if self.selectedType == 1{
                            self.addIntoFavorite(name: "Intermediate \(sender.tag)", title: self.videos[sender.tag].title, url: self.videos[sender.tag].urls)
                        }else{
                            self.addIntoFavorite(name: "Advance \(sender.tag)", title: self.videos[sender.tag].title, url: self.videos[sender.tag].urls)
                        }
                        sender.setImage(#imageLiteral(resourceName: "Fill_Heart"), for: .normal)
                    }
                }else{
                    // SHOW ALERT
                    PopupHelper.alertWithOk(title: "Fail", message: "Unknown error found", controler: self)
                }// end is favorite condition
            }// End referesh favorites Completion handler
        }//End is favorite condition
    }// End favorite button action
}
