//
//  FeedbackViewController.swift
//  FitnessVideoApp
//
//  Created by Buzzware Tech on 27/05/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit
import JGProgressHUD

class FeedbackViewController: UIViewController {
    
    //MARK: IBOUTLET'S
    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var SubjectTF: UITextField!
    @IBOutlet weak var DetailTV: UITextView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    var dataDic = [String:Any]()
    var selectedTitle = String()
    
    //MARK: VARIABLE'S
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.TitleLabel.text = selectedTitle
    }
    //MARK: IBACTION'S
    @IBAction func SendBtnAciton(_ sender: Any) {
        self.CallingApi()
    }
    @IBAction func BackBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func CallingApi() {
        self.dataDic = [String:Any]()
        self.dataDic = [Constant.name: self.NameTF.text!]
        self.dataDic = [Constant.email: self.EmailTF.text!]
        self.dataDic = [Constant.subject: self.SubjectTF.text!]
        self.dataDic = [Constant.msg: self.DetailTV.text!]
        let hud = JGProgressHUD()
        self.contactSupportWebservice(.contact_with_admin, hud: hud)
    }
}



//MARK:- WEWBSERVICE EXTENSION
extension FeedbackViewController:WebServiceResponseDelegate{
    func contactSupportWebservice(_ urltype:webserviceUrl, hud: JGProgressHUD){
        let helper = WebServicesHelper(serviceToCall: urltype, withMethod: .post, havingParameters: self.dataDic, relatedViewController: self,hud: hud)
        helper.delegateForWebServiceResponse = self
        helper.callWebService()
    }
    func webServiceDataParsingOnResponseReceived(url: webserviceUrl?, viewControllerObj: UIViewController?, dataDict: Any, hud: JGProgressHUD) {
        if let data = dataDict as? Dictionary<String, Any>{
            print(data)
            PopupHelper.alertWithOk(title: "Success", message: "Your request successfully completed", controler: self)
            hud.dismiss(animated: true)
        }else{
            hud.textLabel.text = "Data Not Found"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.dismiss(afterDelay: 2, animated: true)
        }
    }
}
