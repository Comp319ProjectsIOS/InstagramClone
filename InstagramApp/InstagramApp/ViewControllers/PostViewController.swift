//
//  PostViewController.swift
//  InstagramApp
//
//  Created by Melih on 5.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import UIKit


extension PostViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage? {
            postImageView.image = image
            self.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

extension PostViewController: UINavigationControllerDelegate {
    
}

extension PostViewController: FirebaseUtilitiesDelegate {
    func presentAlert(title: String, message: String) {
        presentAlertHelper(self, title: title, message: message)
    }
    func dismissPage() {
        let vc = self.storyboard?.instantiateViewController(identifier: "tabVC")
        self.navigationController?.viewControllers = [vc!]    }
}

class PostViewController: UIViewController {
    @IBOutlet weak var postDescriptionLabel: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    
    let picker = UIImagePickerController()
    var image: UIImage?
    let firebaseUtilities = FirebaseUtilities.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post"
        picker.delegate = self
        firebaseUtilities.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseUtilities.delegate = self
        parent?.title = "Post"
    }
    
    @IBAction func postTapped(_ sender: Any) {
        guard let postDescription = postDescriptionLabel.text else {
            return presentAlertHelper(self, title: "Error", message: "Please, fill in all required fields")
        }
        if let image = image {
            let data = image.jpegData(compressionQuality: 0.5)
            firebaseUtilities.postImage(description: postDescription ,data: data)
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
