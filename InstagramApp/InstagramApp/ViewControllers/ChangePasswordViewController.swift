//
//  ChangePasswordViewController.swift
//  InstagramApp
//
//  Created by Başak Çörtük on 17.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import UIKit

extension ChangePasswordViewController: FirebaseUtilitiesDelegate {
    func dismissPage() {
        self.navigationController?.popViewController(animated: true)
    }
    func presentAlert(title: String, message: String) {
        presentAlertHelper(self, title: title, message: message)
    }
}

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var firebaseUtilities = FirebaseUtilities.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseUtilities.delegate = self
        title = "Change Password"
        
    }
    
    
    @IBAction func changePasswordTapped(_ sender: Any) {
        if let password = passwordTextField.text {
            if let oldPassword = oldPasswordTextField.text {
                firebaseUtilities.changePassword(password: password, oldPassword: oldPassword)
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
