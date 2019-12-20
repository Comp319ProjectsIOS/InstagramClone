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
    func loginSuccess()
    func postDataFetched(postList: [Post])
    func userDataFetched(userList: [User])
    func postsForProfileFetched(postList: [Post])
    func commentsForPostFetched(commentList: [Comment])
    func changeUI()
}

extension FirebaseUtilitiesDelegate {
    func presentAlert(title: String, message: String) {
    }
    func dismissPage() {
    }
    func loginSuccess() {
    }
    func postDataFetched(postList: [Post]) {
    }
    func userDataFetched(userList: [User]) {
    }
    func postsForProfileFetched(postList: [Post]) {
    }
    func commentsForPostFetched(commentList: [Comment]) {
    }
    func changeUI(){
    }
}

class FirebaseUtilities {
    var delegate: FirebaseUtilitiesDelegate?
    let storage = Storage.storage()
    var storageRef: StorageReference
    var userDict = [String : Any]()
    var userArray = [User]()
    var postArray = [Post]()
    var friendArray = [User]()
    var friendPostArray = [Post]()
    static let firebaseUtilities = FirebaseUtilities()
    
    private init() {
        storageRef = storage.reference(forURL: "gs://instagramclone-b86bf.appspot.com")
    }
    
    static func getInstance() -> FirebaseUtilities {
        return firebaseUtilities
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
                        UserDefaults.standard.set(email, forKey: "email")
                        UserDefaults.standard.set(password, forKey: "password")
                        self.delegate?.loginSuccess()
                    }
                }
            }
        }
    }
    func autoLogin(){
        if Auth.auth().currentUser != nil {
            self.delegate?.loginSuccess()
        }
    }
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.delegate?.dismissPage()
        } catch {
            self.delegate?.presentAlert(title: "Error", message: "There was an error during sign out")
        }
    }
    func getCurrentUserUid() -> String {
        if let currentUser = Auth.auth().currentUser {
            return currentUser.uid
        }
        return "error"
    }
    
    func signUp(email: String?, password: String?, data: Data?, username: String){
        if let email = email {
            if let password = password {
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if let error = error {
                        self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        if let user = user {
                            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                            changeRequest?.displayName = username
                            changeRequest?.commitChanges(completion: nil)
                            let imageRef = self.storageRef.child("profileImages").child("\(user.user.uid).jpg")
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
                                            Firestore.firestore().collection("users").document(user.user.uid).setData(userInfo) { (error) in
                                                if let error = error {
                                                    self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                                                    return
                                                }
                                                UserDefaults.standard.set(email, forKey: "email")
                                                UserDefaults.standard.set(password, forKey: "password")
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
    func addComment(postId: String, comment: String) {
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            let username = currentUser.displayName
            let timeStamp = String(NSDate.timeIntervalSinceReferenceDate)
            let dataRef = Firestore.firestore().collection("comments").document(postId).collection("commentObjects").document()
            let commentInfo: [String: Any] = ["username": username!,
                                              "comment": comment,
                                              "uid": uid,
                                              "commentId": timeStamp]
            dataRef.setData(commentInfo) { (error) in
                if let error = error {
                    self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                self.delegate?.dismissPage()
            }
        }
    }
    func addFriend (user: User?) {
        if let user = user {
            if let currentUser = Auth.auth().currentUser {
                let selfUid = currentUser.uid
                let friendUid = user.uid!
                var dataRef = Firestore.firestore().collection("users").document(selfUid).collection("friends").document(friendUid)
                var friendInfo: [String: Any] = ["uid": friendUid]
                dataRef.setData(friendInfo) { (error) in
                    if let error = error {
                        self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                        return
                    }
                }
                dataRef = Firestore.firestore().collection("users").document(friendUid).collection("friends").document(selfUid)
                friendInfo = ["uid": selfUid]
                dataRef.setData(friendInfo) { (error) in
                    if let error = error {
                        self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                        return
                    }
                    self.fetchFriends()
                    self.delegate?.changeUI()
                }
                
            }
        }
    }
    
    func deleteFriend (user: User?) {
        if let user = user {
            if let currentUser = Auth.auth().currentUser {
                let selfUid = currentUser.uid
                let friendUid = user.uid!
                var dataRef = Firestore.firestore().collection("users").document(selfUid).collection("friends").document(friendUid)
                dataRef.delete { (error) in
                    if let error = error {
                        self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                        return
                    }
                }
                dataRef = Firestore.firestore().collection("users").document(friendUid).collection("friends").document(selfUid)
                dataRef.delete { (error) in
                    if let error = error {
                        self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                        return
                    }
                    self.fetchFriends()
                    self.delegate?.changeUI()
                }
            }
        }
    }
    
    func postImage (description: String, data: Data?) {
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            let dataRef = Firestore.firestore().collection("posts")
            let timeStamp = NSDate.timeIntervalSinceReferenceDate
            let imageRef = storageRef.child("posts").child(uid).child("\(timeStamp).jpg")
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
                            if let username = currentUser.displayName as String? {
                                let postInfo: [String: Any] = ["description": description,
                                                               "urlToPostImage": url.absoluteString,
                                                               "username": username,
                                                               "postId": String(timeStamp)]
                                dataRef.document(uid).collection("postObjects").document(String(timeStamp)).setData(postInfo) { (error) in
                                    if let error = error {
                                        self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                                        return
                                    }
                                    self.delegate?.dismissPage()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func fetchUsers() {
        userDict = [String : Any]()
        userArray = []
        postArray = []
        let dataRef = Firestore.firestore()
        dataRef.collection("users").getDocuments() {(querySnapshot, err) in
            if let err = err {
                self.delegate?.presentAlert(title: "Error", message: err.localizedDescription)
                return
            } else {
                for document in querySnapshot!.documents {
                    let userData = document.data()
                    var userObject = User()
                    self.userDict.updateValue(document.data(), forKey: document.documentID)
                    //adding user to user array
                    if let username = userData["userName"] as? String, let urlToImage = userData["urlToImage"] as? String, let uid = userData["uid"] as? String {
                        userObject.imageRef = urlToImage
                        userObject.uid = uid
                        userObject.userName = username
                        self.userArray.append(userObject)
                    }
                    self.fetchPosts(uid: document.documentID)
                }
            }
            self.delegate?.userDataFetched(userList: self.userArray)
        }
    }
    func fetchFriends() {
        friendArray = []
        friendPostArray = []
        let dataRef = Firestore.firestore()
        if let currentUser = Auth.auth().currentUser {
            let uid = currentUser.uid
            dataRef.collection("users").document(uid).collection("friends").getDocuments() {(querySnapshot, err) in
                if let err = err {
                    self.delegate?.presentAlert(title: "Error", message: err.localizedDescription)
                } else {
                    for friend in querySnapshot!.documents {
                        let friendData = friend.data()
                        if let friendUid = friendData["uid"] as? String {
                            var friendObject = User()
                            if let friend = self.userDict[friendUid] as? [String : Any] {
                                if let username = friend["userName"] as? String, let urlToImage = friend["urlToImage"] as? String, let uid = friend["uid"] as? String {
                                    friendObject.imageRef = urlToImage
                                    friendObject.uid = uid
                                    friendObject.userName = username
                                    self.friendArray.append(friendObject)
                                }
                                self.fetchPosts(uid: friendUid, isFriend: true)
                            }
                        }
                    }
                }
            }
        }
    }
    func fetchPosts(uid: String, isFriend: Bool = false) {
        let dataRef = Firestore.firestore()
        dataRef.collection("posts").document(uid).collection("postObjects").getDocuments() {(querySnapshot, err) in
            if let err = err {
                self.delegate?.presentAlert(title: "Error", message: err.localizedDescription)
                return
            } else {
                for post in querySnapshot!.documents {
                    let postData = post.data()
                    var postObject = Post()
                    //adding the post object to the post array...
                    if let description = postData["description"] as? String, let urlToPostImage = postData["urlToPostImage"] as? String, let username = postData["username"] as? String, let postId = postData["postId"] as? String {
                        postObject.description = description
                        postObject.postId = postId
                        postObject.urlToPostImage = urlToPostImage
                        postObject.username = username
                        postObject.uid = uid
                        if isFriend {
                            self.friendPostArray.append(postObject)
                        } else {
                            self.postArray.append(postObject)
                        }
                    }
                }
            }
            if isFriend {
                self.friendPostArray.sort(by: { $0.postId! > $1.postId! } )
                self.delegate?.postDataFetched(postList: self.friendPostArray)
            } else {
                self.postArray.sort(by: { $0.postId! > $1.postId! } )
                self.delegate?.postDataFetched(postList: self.postArray)
            }
        }
    }
    func fetchPostsForProfile(uid: String){
        var postsArray: [Post] = []
        let dataRef = Firestore.firestore()
        dataRef.collection("posts").document(uid).collection("postObjects").getDocuments() {(querySnapshot, err) in
            if let err = err {
                self.delegate?.presentAlert(title: "Error", message: err.localizedDescription)
                return
            } else {
                for post in querySnapshot!.documents {
                    let postData = post.data()
                    var postObject = Post()
                    if let description = postData["description"] as? String, let urlToPostImage = postData["urlToPostImage"] as? String, let username = postData["username"] as? String, let postId = postData["postId"] as? String {
                        postObject.description = description
                        postObject.postId = postId
                        postObject.urlToPostImage = urlToPostImage
                        postObject.username = username
                        postObject.uid = uid
                        postsArray.append(postObject)
                    }
                }
            }
            postsArray.sort(by: { $0.postId! > $1.postId! })
            self.delegate?.postsForProfileFetched(postList: postsArray)
        }
    }
    func fetchComments(postId: String) {
        var commentsArray: [Comment] = []
        let dataRef = Firestore.firestore()
        dataRef.collection("comments").document(postId).collection("commentObjects").getDocuments { (querySnapshot, err) in
            for comment in querySnapshot!.documents {
                let commentData = comment.data()
                var commentObject = Comment()
                if let commentDescription = commentData["comment"] as? String, let commenterUid = commentData["uid"] as? String, let commenterUserName = commentData["username"] as? String, let commentId = commentData["commentId"] as? String {
                    commentObject.comment = commentDescription
                    commentObject.uid = commenterUid
                    commentObject.username = commenterUserName
                    commentObject.commentId = commentId
                    commentsArray.append(commentObject)
                }
            }
            commentsArray.sort(by: { $0.commentId! > $1.commentId! })
            self.delegate?.commentsForPostFetched(commentList: commentsArray)
        }
    }
    func changePassword(password: String, oldPassword: String) {
        if let currentUser = Auth.auth().currentUser {
            if let email = currentUser.email {
                let credential = EmailAuthProvider.credential(withEmail: email, password: oldPassword)
                currentUser.reauthenticate(with: credential, completion: { (authData, error) in
                    if let error = error {
                        self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                    } else {
                        // User re-authenticated.
                        Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
                            if let error = error {
                                self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                            } else {
                                self.delegate?.dismissPage()
                            }
                        })
                    }
                })
            }
        }
    }
    func changeProfileImage(data: Data?) {
        if let currentUser = Auth.auth().currentUser {
        let uid = currentUser.uid
        let username = currentUser.displayName
            let imageRef = storageRef.child("profileImages").child("\(uid).jpg")
            if let imageData = data {
                imageRef.delete { (error) in
                    if let error = error{
                        self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                    } else {
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
                                    let userInfo: [String: Any] = ["uid": uid,
                                                                   "userName": username!,
                                                                   "urlToImage": url.absoluteString]
                                    let dataRef = Firestore.firestore().collection("users").document(uid)
                                    dataRef.setData(userInfo) { (error) in
                                        if let error = error {
                                            self.delegate?.presentAlert(title: "Error", message: error.localizedDescription)
                                            return
                                        }
                                        self.fetchUsers()
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
