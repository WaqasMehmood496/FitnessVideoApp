//
//  FirstPageViewController.swift
//  FitnessVideoApp
//
//  Created by Asad on 02/03/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import UIKit
import ExpandingMenu

class FirstPageViewController: UIViewController {
    
    //MARK: IBOUTLET'S
    @IBOutlet weak var Create_Btn: UIButton!
    @IBOutlet weak var DC_btn: UIButton!
    @IBOutlet weak var Login_Btn: UIButton!
    //MARK: VARIABLE'S
    let menuButtonSize: CGSize = CGSize(width: 40.0, height: 40.0)
    var customView = MyCustomView()
    var backView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Login_Btn.layer.cornerRadius =  Login_Btn.bounds.size.height/2
        DC_btn.layer.cornerRadius = DC_btn.bounds.size.height/2
        Create_Btn.layer.cornerRadius = Create_Btn.bounds.size.height/2
    }
    
    //MARK: IBACTION'S
    @IBAction func MenuBtnAction(_ sender: Any) {
        self.add_Option_View()
        backView.tag = 1122
        self.view.addSubview(backView)
    }
    @IBAction func LoginBtnAction(_ sender: Any) {
        self.changeViewController(identifier: "loginScreenViewController")
    }
    @IBAction func DesignClipBtnAction(_ sender: Any) {
        self.changeViewController(identifier: "selectDesignViewController")
    }
    @IBAction func CreateAccountBtnAction(_ sender: Any) {
        self.performSegue(withIdentifier: "DisclamerAlertSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisclamerAlertSegue"{
            if let disclamerAlertVC = segue.destination as? DisclamerAlertViewController {
                disclamerAlertVC.delegate = self
            }
        }
    }
    
}

//MARK:- OPTION MENU SETUP EXTENSION
extension FirstPageViewController{
    func add_Option_View() {
        
        let xPos = CGFloat(32)
        let yPos = CGFloat(32)
        
        customView = MyCustomView(frame: CGRect(x: xPos, y: yPos, width: 150, height: self.view.frame.height/2))
        customView.clientBtn.addTarget(self, action: #selector(client_Btn), for: .touchUpInside)
        customView.proposalBtn.addTarget(self, action: #selector(proposal_Btn), for: .touchUpInside)
        customView.jobBtn.addTarget(self, action: #selector(job_Btn), for: .touchUpInside)
        customView.invoiceBtn.addTarget(self, action: #selector(invoice_Btn), for: .touchUpInside)
        customView.taskBtn.addTarget(self, action: #selector(task_Btn), for: .touchUpInside)
        
        // Back Light View
        backView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        backView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).withAlphaComponent(0.5)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.removeViewFromSubView(_:)))
        backView.addGestureRecognizer(tap)
        self.backView.addSubview(customView)
    }
    
    @objc func removeViewFromSubView(_ sender: UITapGestureRecognizer? = nil) {
        for view in self.view.subviews{
            if view.tag == 1122{
                view.removeFromSuperview()
            }
        }
    }
    
    @objc func client_Btn() {
        changeViewController(identifier: "TermAndCondition")
    }
    @objc func proposal_Btn() {
        changeViewController(identifier: "PrivacyPolicy")
    }
    @objc func job_Btn() {
        //changeViewController(identifier: "New Job")
    }
    @objc func invoice_Btn() {
        changeViewController(identifier: "FeedbackAndContactUs")
    }
    @objc func task_Btn() {
        changeViewController(identifier: "FeedbackAndContactUs")
    }
    
    func changeViewController(identifier:String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: identifier)
        self.present(newViewController, animated: true, completion: nil)
    }
    
    //DELEGATE METHODS
    func createNewAccountDelegate() {
        self.changeViewController(identifier: "CreateAccountViewController")
    }
}
