//
//  Alert.swift
//  InstagramApp
//
//  Created by Melih on 5.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import Foundation
import UIKit

public func PresentAlert(_ viewController: UIViewController, title: String, message: String) {
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
      viewController.present(alert, animated: true, completion: nil)
  }
