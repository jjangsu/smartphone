//
//  AppDelegate.swift
//  QuickActions
//
//  Created by Neil Smyth on 10/7/16.
//  Copyright © 2016 eBookFrenzy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let shortcut2 = UIMutableApplicationShortcutItem(type: "SearchMusic",
                localizedTitle: "Search",
                localizedSubtitle: "Find a track to play",
                icon: UIApplicationShortcutIcon(type: .search),
                userInfo: nil
        )

        let shortcut3 = UIMutableApplicationShortcutItem(type: "AddMusic",
                localizedTitle: "Add Track",
                localizedSubtitle: "Add track to playlist",
                icon: UIApplicationShortcutIcon(type: .add),
                userInfo: nil
        )

        application.shortcutItems = [shortcut2, shortcut3]

        
        return true
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        switch (shortcutItem.type) {
        case "PlayMusic" :
            notifyUser(message: shortcutItem.localizedTitle)
        case "PauseMusic" :
            notifyUser(message: shortcutItem.localizedTitle)
        case "SearchMusic" :
            notifyUser(message: shortcutItem.localizedTitle)
        case "AddMusic" :
            notifyUser(message: shortcutItem.localizedTitle)
        default:
            break
        }
        completionHandler(true)
    }

    func notifyUser(message: String) {

        let alertController = UIAlertController(title: "Quick Action",
                        message: message,
                        preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",
                        style: .default,
                        handler: nil)

        alertController.addAction(okAction)

        window!.rootViewController?.present(alertController,
                animated: true, completion: nil)
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

