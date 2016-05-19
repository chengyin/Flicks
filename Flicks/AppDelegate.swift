//
//  AppDelegate.swift
//  Flicks
//
//  Created by chengyin_liu on 5/16/16.
//  Copyright © 2016 Chengyin Liu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)

    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)

    // Set up the first View Controller
    let vc1 = storyboard.instantiateViewControllerWithIdentifier("MoviesNavigationController")
    vc1.tabBarItem.title = "Now Playing"
    vc1.tabBarItem.image = UIImage(named: "two_tickets.png")
    vc1.tabBarItem.selectedImage = UIImage(named: "two_tickets_filled.png")

    // Set up the second View Controller
    let vc2 = storyboard.instantiateViewControllerWithIdentifier("MoviesNavigationController") as! UINavigationController
    let listController = vc2.viewControllers[0] as! ViewController
    listController.movieType = .TopRated
    vc2.tabBarItem.title = "Top Rated"
    vc2.tabBarItem.image = UIImage(named: "rating.png")
    vc2.tabBarItem.selectedImage = UIImage(named: "rating_filled.png")

    // Set up the Tab Bar Controller to have two tabs
    let tabBarController = UITabBarController()
    tabBarController.viewControllers = [vc1, vc2]
    tabBarController.tabBar.barStyle = .Black
    tabBarController.tabBar.tintColor = Colors.red

    // Make the Tab Bar Controller the root view controller
    window?.rootViewController = tabBarController
    window?.makeKeyAndVisible()

    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

