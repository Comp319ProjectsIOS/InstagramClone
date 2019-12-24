//
//  MyProfileViewController.swift
//  InstagramApp
//
//  Created by Başak Çörtük on 17.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import UIKit
import Kingfisher

extension MyProfileViewController: FirebaseUtilitiesDelegate {
    func postsForProfileFetched(postList: [Post]) {
        postArray = postList
        postsCollectionView.reloadData()
        hideActivityIndicator()
    }
    func presentAlert(title: String, message: String) {
        presentAlertHelper(self, title: title, message: message)
    }
}

extension MyProfileViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "myProfileCell", for: indexPath) as! MyProfileCollectionViewCell
        let index = indexPath.row
        let post = postArray[index]
        let url = URL(string: post.urlToPostImage!)
        item.postImageView.kf.setImage(with: url)
        return item
    }
}

class MyProfileViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postsCollectionView: UICollectionView!
    let firebaseUtilities = FirebaseUtilities.getInstance()
    var postArray: [Post] = []
    var currentUserUid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseUtilities.delegate = self
        title = "My Profile"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        parent?.title = "My Profile"
        firebaseUtilities.delegate = self
        currentUserUid = firebaseUtilities.getCurrentUserUid()
        getPosts()
        loadData()
    }
    
    func getPosts() {
        if let currentId = self.currentUserUid {
            showActivityIndicator()
            firebaseUtilities.fetchPostsForProfile(uid: currentId)
        }
    }
    
    func loadData() {
        if let userId = currentUserUid{
            if let userData = firebaseUtilities.userDict["\(userId)"] as? [String : Any]{
                var user = User()
                if let username = userData["userName"] as? String, let urlToImage = userData["urlToImage"] as? String, let uid = userData["uid"] as? String {
                    user.imageRef = urlToImage
                    user.uid = uid
                    user.userName = username
                }
                usernameLabel.text = user.userName
                profileImageView.kf.setImage(with: URL(string: user.imageRef!))
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "myProfileCellSegue" {
            let cell = sender as! MyProfileCollectionViewCell
            let indexPath = postsCollectionView.indexPath(for: cell)
            if let indexPath = indexPath {
                let post = postArray[indexPath.row]
                let destination = segue.destination as! PostDetailViewController
                destination.selectedPost = post
            }
        }
    }
    
}
