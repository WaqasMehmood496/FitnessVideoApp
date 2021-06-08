//
//  VideoModel.swift
//  FitnessVideoApp
//
//  Created by Buzzware Tech on 28/05/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import Foundation
import UIKit

class VideoModel: Codable {
    
    var basic:[VideoTypeModel]!
    var intermediate:[VideoTypeModel]!
    var advance:[VideoTypeModel]!
    
    init(basic: [VideoTypeModel]? = nil,intermediate:[VideoTypeModel]? = nil,advance:[VideoTypeModel]? = nil) {
        self.basic = basic
        self.intermediate = intermediate
        self.advance = advance
    }
    
    init?(dic:NSDictionary) {
        
        if let basic = (dic as AnyObject).value(forKey: Constant.basic) as? NSArray{
            var basicArray = [VideoTypeModel]()
            for package in basic{
                basicArray.append(VideoTypeModel(dic: package as! NSDictionary)!)
            }
            self.basic = basicArray
        }
        
        if let intermediate = (dic as AnyObject).value(forKey: Constant.intermediate) as? NSArray{
            var intermediateArray = [VideoTypeModel]()
            for package in intermediate{
                intermediateArray.append(VideoTypeModel(dic: package as! NSDictionary)!)
            }
            self.intermediate = intermediateArray
        }
        
        if let advance = (dic as AnyObject).value(forKey: Constant.advance) as? NSArray{
            var advanceArray = [VideoTypeModel]()
            for package in advance{
                advanceArray.append(VideoTypeModel(dic: package as! NSDictionary)!)
            }
            self.advance = advanceArray
        }
    }
}

class VideoTypeModel: Codable {
    
    var title:String!
    var description:String!
    var urls:String!
    var isFavorite:Bool!
    //var image:UIImage!
    
    init(title: String? = nil,description:String? = nil,urls:String? = nil,image:UIImage? = nil,isFavorite:Bool? = nil) {
        self.title = title
        self.description = description
        self.urls = urls
        self.isFavorite = isFavorite
        //self.image = image
    }
    
    init?(dic:NSDictionary) {
        
        let title = (dic as AnyObject).value(forKey: Constant.title) as! String
        let description = (dic as AnyObject).value(forKey: Constant.description) as! String
        let urls = (dic as AnyObject).value(forKey: Constant.urls) as! String
        let isFavorite = (dic as AnyObject).value(forKey: Constant.isFavorite) as? Bool
        
//        if let image = (dic as AnyObject).value(forKey: Constant.image) as? UIImage {
//            self.image = image
//        }
        
        self.title = title
        self.description = description
        self.urls = urls
        self.isFavorite = isFavorite
    }
}

