//
//  FirebaseUtilities.swift
//  InstagramApp
//
//  Created by Melih on 5.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

protocol FirebaseUtilitiesDelegate {
    func presentAlert(title: String, message: String)
    func dismissPage()
}

extension FirebaseUtilitiesDelegate {
    func presentAlert(title: String, message: String) {
    }
    func dismissPage(){
    }
}

class FirebaseUtilities {
    var delegate: FirebaseUtilitiesDelegate?
    let storage = Storage.storage()
    var storageRef: StorageReference
    
    
    init() {
        storageRef = storage.reference(forURL: "gs://instagramclone-b86bf.appspot.com")
    }
    
    func userForgotPassword(email: String?) {
        if let email = email{
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if let error = error {
                    self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                    return
                }else {
                    self.delegate?.presentAlert(title: "A reset password link has been sent to you!", message: "Please check your emails.")
                }
            }
        }
    }
    
    func login(email: String?, password: String?) {
        if let email = email {
            if let password = password {
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if let error = error {
                        self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        print("You are sign in.")
                    }
                }
            }
        }
    }
    
    func signUp(email: String?, password: String?, data: Data?, username: String){
        if let email = email {
            if let password = password {
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if let error = error {
                        self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        if let user = user {
                            let imageRef = self.storageRef.child("\(user.user.uid).jpg")
                            if let imageData = data {
                                let uploadTask = imageRef.putData(imageData, metadata: nil) { (metaData, error) in
                                    if let error = error {
                                        self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                                        return
                                    }
                                    imageRef.downloadURL { (url, error) in
                                        if let error = error {
                                            self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                                            return
                                        }
                                        if let url = url {
                                            let userInfo: [String: Any] = ["uid": user.user.uid,
                                                                           "userName": username,
                                                                           "urlToImage": url.absoluteString]
                                            let dataRef = Firestore.firestore().collection("users").document().setData(userInfo) { (error) in
                                                if let error = error {
                                                    self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                                                    return
                                                }
                                                UserDefaults.standard.set(user.user.uid, forKey: "uid")
                                                self.delegate?.dismissPage()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func postImage (data: Data?) {
        let uid = Auth.auth().currentUser!.uid
        let dataRef = Firestore.firestore().collection("posts")
        
        let timeStamp = NSDate.timeIntervalSinceReferenceDate
        let imageRef = storageRef.child("posts").child(uid).child("\(timeStamp).jpg")
    }
}
