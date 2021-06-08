//
//  favouriteViewController.swift
//  FitnessVideoApp
//
//  Created by Asad on 03/03/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import JGProgressHUD

class favouriteViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    //MARK: IBOUTLET'S
    @IBOutlet weak var favCollection: UICollectionView!
    
    //MARK: VARIABLE'S
    var mAuthFirebase = Auth.auth()
    var ref: DatabaseReference!
    var favoritesArray = [FavoriteModel]()
    var selectedVideo = IndexPath()
    let basic = ["aa1","aa2","aa3","aa4"]
    let intermediate = ["aa5"]
    let advance = ["aa6","aa7","aa8","aa9","aa10"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.getFavoritesFromFirebase()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayerVC" {
            if let playerVC = segue.destination as? intermVideoViewController {
                playerVC.favoriteVideos = self.favoritesArray
                playerVC.thumbnail = 0
                playerVC.selectedType = 4
                playerVC.selectedVideo = self.selectedVideo
                playerVC.isFavorite = true
            }
        }
    }
}

//MARK:- FUNCTION'S EXTENSION
extension favouriteViewController{
    // GET ALL FAVORITES VIDEOS DATA FROM FIREBASE DATABASE
    func getFavoritesFromFirebase() {
        self.favoritesArray.removeAll()
        let hud = JGProgressHUD()
        hud.show(in: self.view)
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
                    self.favCollection.reloadData()
                    hud.dismiss()
                }// End Snapshot if else statement
                else{
                    hud.dismiss()
                }
            }// End ref Child Completion Block
            hud.dismiss()
        }// End Firebase user id
        else{
            hud.dismiss()
        }
    }// End get favorite method
    
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
    
    // DELETE FAVORITES FROM FIREBASE DATABASE
    func removeFromFavorites(video:FavoriteModel) {
        if let user = mAuthFirebase.currentUser?.uid{
            self.ref.child("Favorite").child(user).child(video.id).removeValue { (error, _ in) in
                if error == nil{
                    self.getFavoritesFromFirebase()
                }else{
                    print(error!.localizedDescription)
                }
            }
        }
    }
}

//MARK:- UICOLLECTION VIEW DELEGATES AND DATASOURCE
extension favouriteViewController{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.favoritesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FavCollectionViewCell
        let image = self.checkType(video: self.favoritesArray[indexPath.row])
        cell.mainImage.image = UIImage(named: image)
        cell.nameLBL.text = self.favoritesArray[indexPath.row].name
        cell.titleLBL.text = self.favoritesArray[indexPath.row].title
        cell.playBtn.addTarget(self, action: #selector(playBtnAction(_:)), for: .touchUpInside)
        cell.fav_btn.setImage(#imageLiteral(resourceName: "Fill_Heart"), for: .normal)
        cell.fav_btn.addTarget(self, action: #selector(favoriteBtnAction(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func playBtnAction(_ sender: UIButton) {
        self.selectedVideo = IndexPath(row: sender.tag, section: 0)
        self.performSegue(withIdentifier: "PlayerVC", sender: nil)
    }
    
    @objc func favoriteBtnAction(_ sender: UIButton) {
        self.removeFromFavorites(video: self.favoritesArray[sender.tag])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}