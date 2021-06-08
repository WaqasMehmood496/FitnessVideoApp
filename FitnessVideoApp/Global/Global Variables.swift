//
//  Global Variables.swift
//  PastaRecipe
//
//  Created by Waqas on 14/12/2020.
//  Copyright © 2020 Buzzware. All rights reserved.
//

import Foundation
import UIKit

let defaults = UserDefaults.standard
let baseUrl = "https://buzzwaretech.com/pastarecipe/Api/"
let userDataKey = "userDataKey"
let favoriteRecipeKey = "favoriteVideosKey"
var userLocation = ""

func ShowAlert(view: UIViewController,message:String,Title:String)
{
    let alert = UIAlertController(title: Title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
        print(message)
    }))
    view.present(alert, animated: true, completion: nil)
}


protocol recipeDelegate {
    func updateRecipe()
}
