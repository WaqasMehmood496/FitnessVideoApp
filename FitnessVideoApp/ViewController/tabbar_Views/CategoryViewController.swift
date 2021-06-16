//
//  CategoryViewController.swift
//  FitnessVideoApp
//
//  Created by Asad on 03/03/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit
import JGProgressHUD

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var basicView: UIView!
    @IBOutlet weak var intermediateView: UIView!
    @IBOutlet weak var AdvanceView: UIView!
    
    var dataDic = [String:Any]()
    var videos = VideoModel()
    var selectedType = 0
    var selectedVideo = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicView.layer.cornerRadius =  basicView.bounds.size.height/4
        intermediateView.layer.cornerRadius =  intermediateView.bounds.size.height/4
        AdvanceView.layer.cornerRadius =  AdvanceView.bounds.size.height/4
        self.VideosApiCall()
    }
    
    @IBAction func BasicBtnAction(_ sender: Any) {
        self.selectedType = 0
        self.performSegue(withIdentifier: "PlayerVC", sender: nil)
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vcc = storyboard.instantiateViewController(withIdentifier: "PlayerVC") as! intermVideoViewController
//        if let basic = self.videos.basic{
//            vcc.videos = basic
//            vcc.thumbnail = 0
//            vcc.selectedType = self.selectedType
//            vcc.selectedVideo = IndexPath(row: 0, section: 0)
//        }
//        
//        self.present(vcc, animated: true, completion: nil)
    }
    @IBAction func ItermediateBtnAction(_ sender: Any) {
        self.selectedType = 1
        self.performSegue(withIdentifier: "PlayerVC", sender: nil)
    }
    @IBAction func AdvanceBtnAction(_ sender: Any) {
        self.selectedType = 2
        self.performSegue(withIdentifier: "PlayerVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayerVC" {
            if let playerVC = segue.destination as? intermVideoViewController {
                if self.selectedType == 0{
                    if let basic = self.videos.basic{
                        playerVC.videos = basic
                        playerVC.thumbnail = 0
                        playerVC.selectedType = self.selectedType
                        playerVC.selectedVideo = IndexPath(row: 0, section: 0)
                    }
                }else if self.selectedType == 1{
                    if let intermediate = self.videos.intermediate{
                        playerVC.videos = intermediate
                        playerVC.thumbnail = 0
                        playerVC.selectedType = self.selectedType
                        playerVC.selectedVideo = IndexPath(row: 0, section: 0)
                    }
                }else{
                    if let intermediate = self.videos.advance{
                        playerVC.videos = intermediate
                        playerVC.thumbnail = 0
                        playerVC.selectedType = self.selectedType
                        playerVC.selectedVideo = IndexPath(row: 0, section: 0)
                    }
                }
            }
        }
    }
    
    func VideosApiCall() {
        self.dataDic = [String:Any]()
        let hud = JGProgressHUD()
        hud.show(in: self.view)
        self.getLoginWebservice(.myvideoslist, hud: hud)
    }
}


//MARK:- WEWBSERVICE EXTENSION
extension CategoryViewController:WebServiceResponseDelegate{
    func getLoginWebservice(_ urltype:webserviceUrl, hud: JGProgressHUD){
        let helper = WebServicesHelper(serviceToCall: urltype, withMethod: .post, havingParameters: self.dataDic, relatedViewController: self,hud: hud)
        helper.delegateForWebServiceResponse = self
        helper.callWebService()
    }
    func webServiceDataParsingOnResponseReceived(url: webserviceUrl?, viewControllerObj: UIViewController?, dataDict: Any, hud: JGProgressHUD) {
        if let data = dataDict as? Dictionary<String, Any>{
            print(data)
            self.videos = VideoModel(dic: data as NSDictionary)!
            hud.dismiss(animated: true)
        }else{
            hud.textLabel.text = "Data Not Found"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2, animated: true)
        }
    }
}
