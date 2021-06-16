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
import ASPVideoPlayer
import AVFoundation
import AVKit

class intermVideoViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, VersaPlayerPlaybackDelegate, ASPVideoPlayerViewDelegate {
    //MARK: IBOUTLET'S
    @IBOutlet weak var interVideoCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var controls: VersaPlayerControls!
    @IBOutlet weak var VideoTitle: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var CreatedTime: UILabel!
    
    //MARK: VARIABLE'S
    var videos = [VideoTypeModel]()
    var favoriteVideos: [FavoriteModel] = []
    var mAuthFirebase = Auth.auth()
    var ref: DatabaseReference!
    var thumbnail = 0
    var selectedType = 0
    let basic = ["aa1","aa2","aa3","aa4"]
    let intermediate = ["aa5"]
    let advance = ["aa6","aa7","aa8","aa9","aa10"]
    var selectedVideo = IndexPath()
    var isFavorite = Bool()
    private let spacingIphone:CGFloat = 15.0
    private let spacingIpad:CGFloat = 30.0
    var previousConstraints: [NSLayoutConstraint] = []
    let playerViewController = AVPlayerViewController()
    var playlist = AVQueuePlayer()
    var totalVideoDuration = Double()
    var observer = (Any).self
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionViewSetup()
        ref = Database.database().reference()
        self.getFavoritesFromFirebase()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        playlist.pause()
    }
    override func viewDidAppear(_ animated: Bool) {
        playlist.play()
    }
    
    @IBAction func BackButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK:- ---------------- HELPING METHOD'S ----------------
extension intermVideoViewController {
    // Setup Collection View
    func collectionViewSetup() {
        
        let layout = UICollectionViewFlowLayout()
        if UIDevice.current.userInterfaceIdiom == .phone{
            layout.sectionInset = UIEdgeInsets(top: spacingIphone, left: spacingIphone, bottom: spacingIphone, right: spacingIphone)
            layout.minimumLineSpacing = spacingIphone
            layout.minimumInteritemSpacing = spacingIphone
        }
        else{
            layout.sectionInset = UIEdgeInsets(top: spacingIpad, left: spacingIpad, bottom: spacingIpad, right: spacingIpad)
            layout.minimumLineSpacing = spacingIpad
            layout.minimumInteritemSpacing = spacingIpad
        }
        
        self.interVideoCollectionView?.collectionViewLayout = layout
    }
}


//MARK:- ---------------- VIDEO PLAYER METHOD'S ----------------
extension intermVideoViewController{
    // PLAY FIRST VIDEO OF ARRAY
    func playVideo() {
        if isFavorite{
            self.navigationItem.title = self.favoriteVideos[selectedVideo.row].title
            self.Description.text = self.favoriteVideos[selectedVideo.row].name
            player(items: getAllPlayList(isFavourte: true))
            self.VideoTitle.text = self.favoriteVideos[selectedVideo.row].title
            self.CreatedTime.text = "2 hours"
        }else{
            self.navigationItem.title = self.videos[selectedVideo.row].title
            self.Description.text = self.videos[selectedVideo.row].description
            player(items: getAllPlayList(isFavourte: false))
            self.VideoTitle.text = self.videos[selectedVideo.row].title
            self.CreatedTime.text = "2 hours"
        }
    }
    
    func getAllPlayList(isFavourte:Bool) -> [AVPlayerItem] {
        var items = [AVPlayerItem]()
        if isFavourte{
            for i in favoriteVideos{
                if let url = URL.init(string: i.url) {
                    let videoUrl = AVPlayerItem(url: url)
                    items.append(videoUrl)
                }
            }
        }else{
            for i in videos{
                if let url = URL.init(string: i.urls) {
                    let videoUrl = AVPlayerItem(url: url)
                    items.append(videoUrl)
                }
            }
        }
        return items
    }
    
    //VIDEO PLAYER METHOD
    func player(items:[AVPlayerItem]) {
        playlist = AVQueuePlayer(items: items)
        playlist.rate = 1
        
        playerViewController.player = playlist
        playerViewController.delegate = self
        playerViewController.view.frame = self.containerView.frame
        playerViewController.showsPlaybackControls = true
        self.containerView.addSubview(playerViewController.view)
        addChild(playerViewController)
        playlist.play()
        playlist.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        playlist.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: .AVPlayerItemDidPlayToEndTime, object: playlist.currentItem)
        
        
    }
    
    //THIS METHODS DETEACT THE TOTAL TIME OF VIDEO AND START MUTE FUNCTION
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "rate") {
            print(playlist.rate)
        }
        if (keyPath == "status") {
            print(playlist.status)
            if let duration = playlist.currentItem?.asset.duration {
                let seconds = CMTimeGetSeconds(duration)
                self.totalVideoDuration = seconds
                print("Seconds :: \(seconds)")
                self.addTheardThatCheckTimeOfMutingVideo()
            }
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification){
        print("Video Finished")
        self.playlist.isMuted = false
    }
    
    //THIS METHOD TRACK THE VIDEO TIME AND WHEN ITS NEAR TO END IT WILL MUTE THE AUDIO BEFORE 5 SECONDS
    func addTheardThatCheckTimeOfMutingVideo() {
        // Invoke callback every second
        let interval = CMTime(seconds:totalVideoDuration - 5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        // Queue on which to invoke the callback
        let mainQueue = DispatchQueue.main
        // Keep the reference to remove
        playlist.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue) { time in
            print(time)
            if let duration = self.playlist.currentItem?.asset.duration {
                let seconds = CMTimeGetSeconds(duration)
                self.totalVideoDuration = seconds
                if time.seconds >= self.totalVideoDuration - 10{
                    self.playlist.isMuted = true
                }else{
                    self.playlist.isMuted = false
                }
            }
        }
    }
    
    // REMOVE VIDEO FROM CURRENT PLAYER
    func removePlayer(url:String) {
        if let url = URL.init(string: url) {
        }
    }
    
    // CHECK TYPE OF VIDEO WHICH IS EITHER BASIC , INTERMEDIATE OR ADVANCE
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
}


//MARK:- ---------------- FIREBASE METHOD'S ----------------
extension intermVideoViewController {
    
    // GET ALL FAVORITES FROM FIREBASE DATABASE
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
                    self.playVideo()
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
    
    // REFRESH ALL FAVORITES FROM FIREBASE DATABASE
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
    
    // DELETE FAVORITES FROM FIREBASE DATABASE
    func removeFavoriteFromFavorites(video:FavoriteModel) {
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
extension intermVideoViewController:UICollectionViewDelegateFlowLayout {
    
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
            cell.favBtn.addTarget(self, action: #selector(favoriteBtnAction(_:)), for: .touchUpInside)
            cell.favBtn.tag = indexPath.row
            
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
            self.navigationItem.title = self.favoriteVideos[indexPath.row].title
            self.VideoTitle.text = self.favoriteVideos[indexPath.row].title
            self.CreatedTime.text = "2 hours"
            self.Description.text = self.favoriteVideos[indexPath.row].name
            self.removePlayer(url: self.favoriteVideos[indexPath.row].url)
            let list = [AVPlayerItem(url: URL(string: self.favoriteVideos[indexPath.row].url)!)]
            player(items: list)
        }else{
            self.title = self.videos[indexPath.row].title
            self.VideoTitle.text = self.videos[indexPath.row].title
            self.CreatedTime.text = "2 hours"
            self.Description.text = self.videos[indexPath.row].description
            self.removePlayer(url: self.videos[indexPath.row].urls)
            let list = [AVPlayerItem(url: URL(string: self.videos[indexPath.row].urls)!)]
            player(items: list)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCellsIphone:CGFloat = 15
        let spacingBetweenCellsIpad:CGFloat = 30
        
        if UIDevice.current.userInterfaceIdiom == .phone{
            let totalSpacing = (2 * self.spacingIphone) + ((numberOfItemsPerRow - 1) * spacingBetweenCellsIphone) //Amount of total spacing in a row
            
            if let collection = self.interVideoCollectionView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width , height: width + spacingBetweenCellsIphone * 2)
            }else{
                return CGSize(width: 0, height: 0)
            }
        }
        else{
            let totalSpacing = (2 * self.spacingIpad) + ((numberOfItemsPerRow - 1) * spacingBetweenCellsIpad) //Amount of total spacing in a row
            
            if let collection = self.interVideoCollectionView{
                let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
                return CGSize(width: width , height: width + spacingBetweenCellsIpad * 2)
            }else{
                return CGSize(width: 0, height: 0)
            }
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
            self.removeFavoriteFromFavorites(video: self.favoriteVideos[sender.tag])
            self.getFavoritesFromFirebase()
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

// MARK:- AVPlayerViewController
extension intermVideoViewController:AVPlayerViewControllerDelegate,AVAudioPlayerDelegate{
}
