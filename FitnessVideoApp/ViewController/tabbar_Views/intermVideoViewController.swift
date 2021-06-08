//
//  intermVideoViewController.swift
//  FitnessVideoApp
//
//  Created by Asad on 04/03/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit
import VersaPlayer

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
    var thumbnail = 0
    var selectedType = 0
    let basic = ["aa1","aa2","aa3","aa4"]
    let intermediate = ["aa5"]
    let advance = ["aa6","aa7","aa8","aa9","aa10"]
    var selectedVideo = IndexPath()
    var isFavorite = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            cell.playBtn.addTarget(self, action: #selector(playBtnAction(_:)), for: .touchUpInside)
            cell.favBtn.addTarget(self, action: #selector(favoriteBtnAction(_:)), for: .touchUpInside)
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
            if selectedType == 0{
                
            }else if selectedType == 1{
                
            }else{
                
            }
        }
    }
}
