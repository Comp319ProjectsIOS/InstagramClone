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
        userForgotPassword(emailTextField: emailTextField, vc: self)
    }
    
    public func userForgotPassword(emailTextField: UITextField, vc: UIViewController) {
        if let email = emailTextField.text {
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if let error = error {
                    PresentAlert(vc, title: "Error", message: error.localizedDescription)
                }
                PresentAlert(vc, title: "A reset password link has been sent to you!", message: "Lütfen \(email) mail adresini kontrol ediniz.")
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
