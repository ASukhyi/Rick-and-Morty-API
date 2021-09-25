//
//  AppDelegate.swift
//  RickAndMorty...
//
//  Created by Андрей on 14.06.2021.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}

