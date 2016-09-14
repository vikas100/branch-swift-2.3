//
//  ViewController.swift
//  Branchio
//
//  Created by Ethan Neff on 7/30/16.
//  Copyright © 2016 Ethan Neff. All rights reserved.
//

import UIKit
import Branch

class IntroViewController: UIViewController {
  let scrollView: UIScrollView = UIScrollView()
  let label: UILabel = UILabel()
  let signupButton: UIButton = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createNav()
    createLabel()
    createListeners()
    createTaps()
    updateHeaderAndLabel()
  }
  
  deinit {
    removeListeners()
  }
}

// MARK: - setup
extension IntroViewController {
  private func createNav() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
  }
  
  private func createLabel() {
    view.addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .Center
    label.lineBreakMode = .ByWordWrapping
    label.numberOfLines = 0
    NSLayoutConstraint.activateConstraints([
      NSLayoutConstraint(item: label, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: label, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 0),
      NSLayoutConstraint(item: label, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: 0),
      ])
  }
}

// MARK: - listeners
extension IntroViewController {
  private func createListeners() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateHeaderAndLabel), name: DeepLinkData.sharedInstance.notification, object: nil)
  }
  
  private func removeListeners() {
    NSNotificationCenter.defaultCenter().removeObserver(self, name: DeepLinkData.sharedInstance.notification, object: nil)
  }
  
  internal func updateHeaderAndLabel() {
    label.text = String(DeepLinkData.sharedInstance.data ?? ["status":"loading..."])
    navigationItem.rightBarButtonItem?.title = DeepLinkData.sharedInstance.location
    navigationItem.leftBarButtonItem?.title = DeepLinkData.sharedInstance.header
  }
}


// MARK: - taps
extension IntroViewController {
  private func createTaps() {
    let triple = UITapGestureRecognizer(target: self, action: #selector(tripleTap(_:)))
    triple.numberOfTapsRequired = 3
    view.addGestureRecognizer(triple)
    
    let double = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
    double.numberOfTapsRequired = 2
    view.addGestureRecognizer(double)
    
    let single = UITapGestureRecognizer(target: self, action: #selector(singleTap(_:)))
    single.numberOfTapsRequired = 1
    single.requireGestureRecognizerToFail(double)
    view.addGestureRecognizer(single)
  }
  
  private dynamic func singleTap(tap: UITapGestureRecognizer) {
    print("single tap")
    let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
    UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
    
    guard let settings = UIApplication.sharedApplication().currentUserNotificationSettings() else { return }
    
    if settings.types == .None {
      let ac = UIAlertController(title: "Can't schedule", message: "Either we don't have permission to schedule notifications, or we haven't asked yet.", preferredStyle: .Alert)
      ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
      presentViewController(ac, animated: true, completion: nil)
      return
    }
    
    let notification = UILocalNotification()
    notification.fireDate = NSDate(timeIntervalSinceNow: 5)
    notification.alertBody = "https://683d.app.link/U4N6gq0Ilw"
    notification.alertAction = "be awesome!"
    notification.soundName = UILocalNotificationDefaultSoundName
    notification.userInfo = ["CustomField1": "w00t"]
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
  }
  
  // share sheet
  private dynamic func doubleTap(tap: UITapGestureRecognizer) {
    print("double tap")
    let branchUniversalObject: BranchUniversalObject = BranchUniversalObject(canonicalIdentifier: "monster/12345")
    branchUniversalObject.title = "Meet Mr. Squiggles"
    branchUniversalObject.contentDescription = "Your friend Josh has invited you to meet his awesome monster, Mr. Squiggles!"
    branchUniversalObject.imageUrl = "https://pupnkittens.files.wordpress.com/2014/02/tumblr_mso9g5hxdj1rylzllo1_500.jpg"
    branchUniversalObject.addMetadataKey("userId", value: "12345")
    branchUniversalObject.addMetadataKey("userName", value: "Josh")
    branchUniversalObject.addMetadataKey("monsterName", value: "Mr. Squiggles")
    
    let linkProperties: BranchLinkProperties = BranchLinkProperties()
    linkProperties.feature = "share"
    linkProperties.channel = "facebook"
    
    branchUniversalObject.showShareSheetWithLinkProperties(linkProperties, andShareText: "Super amazing thing I want to share!", fromViewController: self) { (activity: String?, success: Bool) in
      print(activity, success)
    }
  }
  
  private dynamic func tripleTap(tap: UITapGestureRecognizer) {
    print("triple tap")
    UIApplication.sharedApplication().openURL(NSURL(string: "https://683d.app.link/U4N6gq0Ilw")!)
  }
}
