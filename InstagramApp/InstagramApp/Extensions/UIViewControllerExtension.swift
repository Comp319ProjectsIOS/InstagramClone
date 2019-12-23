//
//  UIViewControllerExtension.swift
//  InstagramApp
//
//  Created by Melih on 23.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import Foundation
import UIKit

fileprivate var aView: UIView?

extension UIViewController {
    func showActivityIndicator() {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView(style: .large)
        ai.center = aView!.center
        ai.startAnimating()
        aView?.addSubview(ai)
        self.view.addSubview(aView!)
        aView?.isUserInteractionEnabled = false
        Timer.scheduledTimer(withTimeInterval: 20, repeats: false) { (t) in
            self.hideActivityIndicator()
        }
    }
    
    func hideActivityIndicator(){
        aView?.removeFromSuperview()
        aView = nil
    }
}
