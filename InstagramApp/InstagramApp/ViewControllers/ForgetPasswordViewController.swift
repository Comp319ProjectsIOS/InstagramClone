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
                    PresentAlert(vc, alertStyle: .alert, title: "Error", message: error.localizedDescription, withCancel: false, withSegueIdentifier: SegueIdentifier())
                }
                PresentAlert(vc, alertStyle: .alert, title: "Sıfırlama maili gönderilmiştir!", message: "Lütfen \(email) mail adresini kontrol ediniz.", withCancel: false, withSegueIdentifier: SegueIdentifier())
            }
        }
    }
    
    public func PresentAlert(_ viewController: UIViewController, alertStyle: UIAlertController.Style, title: String, message: String, withCancel cancel: Bool, withSegueIdentifier identifier: SegueIdentifier) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        let defaultAction = UIAlertAction(title: "Tamam", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
            if identifier.exist {
                viewController.performSegue(withIdentifier: identifier.identifier, sender: nil)
            }
        }
        if cancel {
            let cancelAction = UIAlertAction(title: "İptal", style: .cancel) { (action) in
                alertVC.dismiss(animated: true, completion: nil)
            }
            alertVC.addAction(cancelAction)
        }
        alertVC.addAction(defaultAction)
        viewController.present(alertVC, animated: true, completion: nil)
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
