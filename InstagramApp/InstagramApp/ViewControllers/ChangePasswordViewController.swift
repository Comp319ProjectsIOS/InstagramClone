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
        activateIndicator(activityIndicator: self.activityIndicator, viewController: self, bool: true)
        
        self.navigationController?.popViewController(animated: true)
    }
    func presentAlert(title: String, message: String) {
        presentAlertHelper(self, title: title, message: message)
    }
    func startActivityIndicator(){
        activateIndicator(activityIndicator: self.activityIndicator, viewController: self, bool: true)
    }
}

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var firebaseUtilities = FirebaseUtilities.getInstance()
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Change Password"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseUtilities.delegate = self
    }
    
    
    @IBAction func changePasswordTapped(_ sender: Any) {
        if let password = passwordTextField.text {
            if let oldPassword = oldPasswordTextField.text {
                firebaseUtilities.changePassword(password: password, oldPassword: oldPassword)
            }
        }
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
