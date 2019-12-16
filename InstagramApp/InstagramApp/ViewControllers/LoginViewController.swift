//
//  MainViewController.swift
//  InstagramApp
//
//  Created by Başak Çörtük on 1.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

extension LoginViewController: FirebaseUtilitiesDelegate {
    func presentAlert(title: String, message: String) {
        presentAlertHelper(self, title: title, message: message)
    }
    func loginSuccess() {
        let vc = self.storyboard?.instantiateViewController(identifier: "postVC")
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

class LoginViewController: UIViewController {
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    let firebaseUtilities = FirebaseUtilities()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        firebaseUtilities.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        firebaseUtilities.login(email: emailText.text, password: passwordText.text)
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
