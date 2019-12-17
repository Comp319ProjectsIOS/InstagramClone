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

extension ForgetPasswordViewController: FirebaseUtilitiesDelegate {
    func presentAlert(title: String, message: String) {
        presentAlertHelper(self, title: title, message: message)
    }
    
    
}

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    let firebaseUtilities = FirebaseUtilities.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Forget Password"
        firebaseUtilities.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           firebaseUtilities.delegate = self
       }
    
    @IBAction func resetPasswordTapped(_ sender: Any) {
        firebaseUtilities.userForgotPassword(email: emailTextField.text)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
