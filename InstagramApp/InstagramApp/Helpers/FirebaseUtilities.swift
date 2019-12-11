//
//  FirebaseUtilities.swift
//  InstagramApp
//
//  Created by Melih on 5.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

protocol FirebaseUtilitiesDelegate {
    func presentAlert(title: String, message: String)
}

extension FirebaseUtilities: FirebaseUtilitiesDelegate {
    func presentAlert(title: String, message: String) {
    }
    
}

class FirebaseUtilities {
    var delegate: FirebaseUtilitiesDelegate?
    
    func userForgotPassword(email: String?) {
        if let email = email{
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if let error = error {
                    self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                }
                self.delegate?.presentAlert(title: "A reset password link has been sent to you!", message: "Please \(email) check your emails.")
            }
        }
    }
    
    func login(email: String?, password: String?) {
           if let email = email {
               if let password = password {
                   Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                       if let error = error {
                        self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                       } else {
                           print("You are sign in.")
                       }
                   }
               }
           }
       }
}
