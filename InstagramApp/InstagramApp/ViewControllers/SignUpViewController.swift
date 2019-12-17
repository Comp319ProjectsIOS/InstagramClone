//
//  SingUpViewController.swift
//  InstagramApp
//
//  Created by Başak Çörtük on 5.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import UIKit



extension SignUpViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage? {
            profileImageView.image = image
            self.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

extension SignUpViewController: UINavigationControllerDelegate {
    
}

extension SignUpViewController: FirebaseUtilitiesDelegate {
    func presentAlert(title: String, message: String) {
        presentAlertHelper(self, title: title, message: message)
    }
    func dismissPage() {
         if let firstViewController = self.navigationController?.viewControllers.first {
               self.navigationController?.popToViewController(firstViewController, animated: true)
           } 
    }
}
class SignUpViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    let picker = UIImagePickerController()
    var image: UIImage?
    let firebaseUtilities = FirebaseUtilities.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        picker.delegate = self
        firebaseUtilities.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           firebaseUtilities.delegate = self
       }
    
    @IBAction func signUpTapped(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, let username = userNameTextField.text else {
           return presentAlertHelper(self, title: "Error", message: "Please, fill in all required fields")
        }
        if let image = image {
            let data = image.jpegData(compressionQuality: 0.5)
            firebaseUtilities.signUp(email: email, password: password, data: data, username: username)
        }
        
        
    }
    
    @IBAction func selectImageTapped(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
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
