//
//  PodcastModel.swift
//  Prosperity Financial
//
//  Created by Buzzware Tech on 27/05/2021.
//

import Foundation
class LoginModel: Codable {
    
    var age:String!
    var email:String!
    var f_name:String!
    var full_name:String!
    var gender:String!
    var height:String!
    var l_name:String!
    var mobile_number:String!
    var password:String!
    var weight:String!
    var image:String!
    
    init(age: String? = nil,email:String? = nil,f_name:String? = nil,full_name:String? = nil,gender:String? = nil,  height: String? = nil,l_name:String? = nil,mobile_number:String? = nil,password:String? = nil,weight:String? = nil,image:String? = nil) {
        self.age = age
        self.email = email
        self.f_name = f_name
        self.full_name = full_name
        self.gender = gender
        self.height = height
        self.l_name = l_name
        self.mobile_number = mobile_number
        self.password = password
        self.weight = weight
        self.image = image
    }
    
    init?(dic:NSDictionary) {
        
        let age = (dic as AnyObject).value(forKey: Constant.age) as! String
        let email = (dic as AnyObject).value(forKey: Constant.email) as! String
        let f_name = (dic as AnyObject).value(forKey: Constant.f_name) as! String
        let full_name = (dic as AnyObject).value(forKey: Constant.full_name) as! String
        let gender = (dic as AnyObject).value(forKey: Constant.gender) as? String
        let height = (dic as AnyObject).value(forKey: Constant.height) as! String
        let l_name = (dic as AnyObject).value(forKey: Constant.l_name) as! String
        let mobile_number = (dic as AnyObject).value(forKey: Constant.mobile_number) as! String
        let password = (dic as AnyObject).value(forKey: Constant.password) as! String
        let weight = (dic as AnyObject).value(forKey: Constant.weight) as? String
        let image = (dic as AnyObject).value(forKey: Constant.image) as? String
        
        self.age = age
        self.email = email
        self.f_name = f_name
        self.full_name = full_name
        self.gender = gender
        self.height = height
        self.l_name = l_name
        self.mobile_number = mobile_number
        self.password = password
        self.weight = weight
        self.image = image
    }
}
