//
//  AppDelegate.swift
//  TwilioSyncCollabToDoList
//
//  Created by Elizabeth Siegle on 9/18/17.
//  Copyright © 2017 Elizabeth Siegle. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(FirebaseApp application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
        -> Bool {
            FirebaseApp.configure()
            return true
    }
}

