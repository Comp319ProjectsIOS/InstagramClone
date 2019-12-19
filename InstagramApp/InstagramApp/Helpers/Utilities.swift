//
//  Alert.swift
//  InstagramApp
//
//  Created by Melih on 5.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import Foundation
import UIKit

public func presentAlertHelper(_ viewController: UIViewController, title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    viewController.present(alert, animated: true, completion: nil)
}

public func activateIndicator(activityIndicator: UIActivityIndicatorView, viewController: UIViewController, bool: Bool) {
    if bool {
        activityIndicator.center = viewController.view.center
        activityIndicator.hidesWhenStopped = true
        viewController.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    } else {
        activityIndicator.stopAnimating()
    }
    
}
