//
//  AppDelegate.swift
//  House
//
//  Created by Sundara Sastha on 23/12/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        var isUniversalLinkClick: Bool = false
//        if (launchOptions![UIApplication.LaunchOptionsKey.userActivityDictionary] != nil) {
//             let activityDictionary = launchOptions![UIApplication.LaunchOptionsKey.userActivityDictionary] as? [AnyHashable: Any] ?? [AnyHashable: Any]()
//             let activity = activityDictionary["UIApplicationLaunchOptionsUserActivityKey"] as? NSUserActivity ?? NSUserActivity()
//             if (activity != nil) {
//                isUniversalLinkClick = true
//             }
//         }
//         if (isUniversalLinkClick) {
//         // app opened via clicking a universal link.
//         } else {
//         // set the initial viewcontroller
//         }
         return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

