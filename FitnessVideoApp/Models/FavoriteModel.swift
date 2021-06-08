//
//  FavoriteModel.swift
//  FitnessVideoApp
//
//  Created by Buzzware Tech on 31/05/2021.
//  Copyright © 2021 Asadullah. All rights reserved.
//

import Foundation
import UIKit

class FavoriteModel: Codable {
    var id:String!
    var name:String!
    var title:String!
    var url:String!
    
    init(id: String? = nil,name: String? = nil,title:String? = nil,url:String? = nil) {
        self.id = id
        self.name = name
        self.title = title
        self.url = url
    }
    
    init?(dic:NSDictionary) {
        let id = (dic as AnyObject).value(forKey: Constant.id) as! String
        let name = (dic as AnyObject).value(forKey: Constant.name) as! String
        let title = (dic as AnyObject).value(forKey: Constant.title) as! String
        let url = (dic as AnyObject).value(forKey: Constant.url) as? String
        
        self.id = id
        self.name = name
        self.title = title
        self.url = url
    }
}
