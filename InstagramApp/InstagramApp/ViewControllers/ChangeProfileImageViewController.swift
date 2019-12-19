//
//  ChangeProfileImageViewController.swift
//  InstagramApp
//
//  Created by Başak Çörtük on 17.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import UIKit

extension ChangeProfileImageViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage? {
            profileImageView.image = image
            self.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ChangeProfileImageViewController: UINavigationControllerDelegate {
    
}

extension ChangeProfileImageViewController: FirebaseUtilitiesDelegate {
    func presentAlert(title: String, message: String) {
        presentAlertHelper(self, title: title, message: message)
    }
    func dismissPage() {
        if let firstViewController = self.navigationController?.viewControllers.first {
            self.navigationController?.popToViewController(firstViewController, animated: true)
        }
    }
}
class ChangeProfileImageViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    
    let picker = UIImagePickerController()
    var image: UIImage?
    let firebaseUtilities = FirebaseUtilities.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Change Profile Image"
        picker.delegate = self
        firebaseUtilities.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseUtilities.delegate = self
    }
    
    @IBAction func selectImageTapped(_ sender: Any) {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func updateProfileImageTapped(_ sender: Any) {
        if let image = image {
            let data = image.jpegData(compressionQuality: 0.5)
            firebaseUtilities.changeProfileImage(data: data)
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
