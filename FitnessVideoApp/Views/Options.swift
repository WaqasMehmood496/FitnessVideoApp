//
//  Options.swift
//  FSM
//
//  Created by Waqas on 29/12/2020.
//

import Foundation
import UIKit
class MyCustomView: UIView {
    
    let clientBtn = UIButton()
    let proposalBtn = UIButton()
    let jobBtn = UIButton()
    let invoiceBtn = UIButton()
    let taskBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addCustomView()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addCustomView() {
        //MARK: SET BUTTONS
        let btnWidth = CGFloat(200)
        let btnHeight = CGFloat(45.0)
        let btnXPos = CGFloat(20)
        
        //let clientBtn = UIButton()
        clientBtn.frame = CGRect(x: btnXPos, y: 0, width: btnWidth, height: btnHeight)
        clientBtn.setTitle("Terms and conditions", for: .normal)
        clientBtn.contentHorizontalAlignment = .left
        clientBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        //clientBtn.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        //clientBtn.addTarget(self, action: #selector(client_Btn), for: .touchUpInside)
        
        proposalBtn.frame = CGRect(x: btnXPos, y: clientBtn.frame.maxY + 8, width: btnWidth, height: btnHeight)
        proposalBtn.setTitle("Privacy Policy", for: .normal)
        proposalBtn.contentHorizontalAlignment = .left
        proposalBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        //clientBtn.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        //proposalBtn.addTarget(self, action: #selector(proposal_Btn), for: .touchUpInside)
        
        jobBtn.frame = CGRect(x: btnXPos, y: proposalBtn.frame.maxY + 8, width: btnWidth, height: btnHeight)
        jobBtn.setTitle("Setting", for: .normal)
        jobBtn.contentHorizontalAlignment = .left
        jobBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        //jobBtn.addTarget(self, action: #selector(job_Btn), for: .touchUpInside)
        
        invoiceBtn.frame = CGRect(x: btnXPos, y: jobBtn.frame.maxY + 8, width: btnWidth, height: btnHeight)
        invoiceBtn.setTitle("Contact Us", for: .normal)
        invoiceBtn.contentHorizontalAlignment = .left
        invoiceBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        //invoiceBtn.addTarget(self, action: #selector(invoice_Btn), for: .touchUpInside)
        
        taskBtn.frame = CGRect(x: btnXPos, y: invoiceBtn.frame.maxY + 8, width: btnWidth, height: btnHeight)
        taskBtn.setTitle("Feedback", for: .normal)
        taskBtn.contentHorizontalAlignment = .left
        taskBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        //taskBtn.addTarget(self, action: #selector(task_Btn), for: .touchUpInside)

        self.addSubview(clientBtn)
        self.addSubview(proposalBtn)
        self.addSubview(jobBtn)
        self.addSubview(invoiceBtn)
        self.addSubview(taskBtn)
        
        
        //MARK: SET IMAGES
        
        let imageXPos = clientBtn.frame.minX
        let imageWidth = CGFloat(45.0)
        
        
        let clientImg = UIImageView()
        clientImg.frame = CGRect(x: imageXPos - imageWidth - 4, y: 0, width: imageWidth, height: imageWidth)
        clientImg.image = UIImage(named: "18")
        clientImg.contentMode = .scaleAspectFit
        
        let proposalImg = UIImageView()
        proposalImg.frame = CGRect(x: imageXPos  - imageWidth - 4, y: clientBtn.frame.maxY + 8, width: imageWidth, height: imageWidth)
        proposalImg.image = UIImage(named: "21")
        proposalImg.contentMode = .scaleAspectFit
        
        let jobImg = UIImageView()
        jobImg.frame = CGRect(x: imageXPos  - imageWidth - 4, y: proposalBtn.frame.maxY + 8, width: imageWidth, height: imageWidth)
        jobImg.image = UIImage(named: "19")
        jobImg.contentMode = .scaleAspectFit
        
        let invoiceImg = UIImageView()
        invoiceImg.frame = CGRect(x: imageXPos  - imageWidth - 4, y: jobBtn.frame.maxY + 8, width: imageWidth, height: imageWidth)
        invoiceImg.image = UIImage(named: "Contact Support")
        invoiceImg.contentMode = .scaleAspectFit
        
        let taskImg = UIImageView()
        taskImg.frame = CGRect(x: imageXPos  - imageWidth - 4, y: invoiceBtn.frame.maxY + 8, width: imageWidth, height: imageWidth)
        taskImg.image = UIImage(named: "FeedBack")
        taskImg.contentMode = .scaleAspectFit
        
        self.addSubview(clientImg)
        self.addSubview(proposalImg)
        self.addSubview(jobImg)
        self.addSubview(invoiceImg)
        self.addSubview(taskImg)
        
    }
    
}

