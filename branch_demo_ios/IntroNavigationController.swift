//
//  IntroNavigationController.swift
//  Branchio
//
//  Created by ethan on 8/23/16.
//  Copyright © 2016 Ethan Neff. All rights reserved.
//

import UIKit

class IntroNavigationController: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
    pushViewController(IntroViewController(), animated: false)
    navigationBar.tintColor = .blackColor()
  }
}
