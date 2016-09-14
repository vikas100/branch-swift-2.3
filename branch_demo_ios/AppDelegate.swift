//
//  AppDelegate.swift
//  branch_demo_ios
//
//  Created by ethan on 8/24/16.
//  Copyright © 2016 eneff. All rights reserved.
//

import UIKit
import Branch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
}

// MARK: - events
extension AppDelegate {
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    setupDeepLink(launchOptions)
    navigateToFirstController()
    return true
  }
  
  func applicationWillResignActive(application: UIApplication) {}
  
  func applicationDidEnterBackground(application: UIApplication) {}
  
  func applicationWillEnterForeground(application: UIApplication) {}
  
  func applicationDidBecomeActive(application: UIApplication) {}
  
  func applicationWillTerminate(application: UIApplication) {}
}

// MARK: - navigation
extension AppDelegate {
  private func navigateToFirstController() {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    guard let window = window else { return }
    window.backgroundColor = UIColor.whiteColor()
    window.rootViewController = IntroNavigationController()
    window.makeKeyAndVisible()
  }
}

// MARK: - deep links
extension AppDelegate {
  private func setupDeepLink(launchOptions: [NSObject: AnyObject]?) {
    handleDeepLinkLoading("setupDeepLink")
    // Branch.getInstance().setDebug()
    // https://683d.app.link/jlO1EWqV6v
    Branch.getInstance().disableCookieBasedMatching()
    Branch.getInstance().accountForFacebookSDKPreventingAppLaunch()
    Branch.getInstance().initSessionWithLaunchOptions(launchOptions) { (params, error) in
      self.handleDeepLink(params, error: error)
    }
  }
  
  private func handleDeepLink(params: [NSObject: AnyObject]?, error: NSError?) {
    guard error == nil, let params = params else { return print(error) }
    DeepLinkData.sharedInstance.data = params
  }
  
  private func handleDeepLinkLoading(location: String) {
    DeepLinkData.sharedInstance.location = location
  }
  
  func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
    handleDeepLinkLoading("openURL")
    Branch.getInstance().handleDeepLink(url)
    return true
  }
  
  func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
    handleDeepLinkLoading("continueUserActivity")
    Branch.getInstance().continueUserActivity(userActivity)
    return true
  }
}


// MARK: - push
extension AppDelegate {
  func application(application: UIApplication, didReceiveRemoteNotification launchOptions: [NSObject: AnyObject]) {
    print("didReceiveRemoteNotification")
    Branch.getInstance().handlePushNotification(launchOptions)
  }
  
  func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
    print("didReceiveLocalNotification")
    print(notification.alertBody)
  }
}
