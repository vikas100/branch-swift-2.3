//
//  DeepLinkData.swift
//  branch_demo_ios
//
//  Created by ethan on 9/2/16.
//  Copyright © 2016 eneff. All rights reserved.
//

import Foundation

class DeepLinkData {
  static let sharedInstance = DeepLinkData()
  private init() {}
  
  let notification: String = "DeepLinkNotification"
  private(set) var header: String = ""
  var location: String = "" {
    didSet {
      data = nil
    }
  }
  var data: [NSObject: AnyObject]? {
    willSet(params) {
      guard let params = params, let clicked_branch_link = params["+clicked_branch_link"] as? Bool, let is_first_session = params["+is_first_session"] as? Bool else {
        return header = "loading..."
      }
      header = clicked_branch_link ? "from branch" : "not from branch"
      header += is_first_session ? " install" : " open"
    }
    didSet {
      NSNotificationCenter.defaultCenter().postNotificationName(DeepLinkData.sharedInstance.notification, object: nil)
    }
  }
}