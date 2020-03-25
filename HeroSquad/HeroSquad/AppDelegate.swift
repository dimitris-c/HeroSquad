//
//  AppDelegate.swift
//  HeroSquad
//
//  Created by Dimitrios Chatzieleftheriou on 24/03/2020.
//  Copyright © 2020 Decimal Digital. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appController: AppController?
    var container: Services?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let container = ServicesContainer()
        let appController = AppController(window: window, container: container)
        self.window = window
        self.container = container
        self.appController = appController
        self.appController?.start()
        return true
    }

}

