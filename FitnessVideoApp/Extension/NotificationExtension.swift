//
//  NotificationExtension.swift
//  Random VIdeo Call
//
//  Created by Waqas on 02/03/2021.
//  Copyright © 2021 Mecus. All rights reserved.
//

import Foundation
//import GoogleSignIn
//import FBSDKCoreKit

extension Notification.Name {
    
    /// Notification when user successfully sign in using Google
    static var signInGoogleCompleted: Notification.Name {
        return .init(rawValue: #function)
    }
}
