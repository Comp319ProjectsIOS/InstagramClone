//
//  ForgetPasswordViewController.swift
//  InstagramApp
//
//  Created by Melih on 3.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Forget Password"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetPasswordTapped(_ sender: Any) {
        userForgotPassword()
    }
    
    
    // BU KISIM MVC VIOLATE EDIYOR MU??
    public func userForgotPassword() {
        if let email = emailTextField.text {
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if let error = error {
                    PresentAlert(self, title: "Error", message: error.localizedDescription)
                }
                PresentAlert(self, title: "A reset password link has been sent to you!", message: "Please \(email) check your emails.")
            }
        }
    }
    
    
    
      /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
