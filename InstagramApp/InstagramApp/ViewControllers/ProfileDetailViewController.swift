//
//  ProfileDetailViewController.swift
//  InstagramApp
//
//  Created by Başak Çörtük on 16.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import UIKit

extension ProfileDetailViewController: FirebaseUtilitiesDelegate {
    func postsForProfileFetched(postList: [Post]) {
        postArray = postList
        postsCollectionView.reloadData()
        hideActivityIndicator()
    }
    func presentAlert(title: String, message: String) {
        presentAlertHelper(self, title: title, message: message)
    }
    func changeUI() {
        if (buttonState == 0) {
            buttonState = 1
            addFriendButton.setTitle("Remove", for: .normal)
        } else {
            buttonState = 0
            addFriendButton.setTitle("Add Friend", for: .normal)
        }
    }
}

extension ProfileDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! ProfileDetailCollectionViewCell
        let index = indexPath.row
        let post = postArray[index]
        item.postImageView.kf.setImage(with: URL(string: post.urlToPostImage!))
        return item
    }
    
    
}


class ProfileDetailViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postsCollectionView: UICollectionView!
    @IBOutlet weak var addFriendButton: UIButton!
    var selectedUser: User?
    let firebaseUtilities = FirebaseUtilities.getInstance()
    var postArray: [Post] = []
    var buttonState: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseUtilities.delegate = self
        title = "Profile Detail"
        if let user = selectedUser {
            usernameLabel.text = user.userName
            profileImageView.kf.setImage(with: URL(string: user.imageRef!)!)
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseUtilities.delegate = self
        if (buttonState == 0) {
            addFriendButton.setTitle("Add Friends", for: .normal)
        } else {
            addFriendButton.setTitle("Remove", for: .normal)
        }
    }
    
    @IBAction func addFriendTapped(_ sender: Any) {
        showActivityIndicator()
        if (buttonState == 0) {
            firebaseUtilities.addFriend(user: selectedUser)
        } else {
            firebaseUtilities.deleteFriend(user: selectedUser)
        }
        hideActivityIndicator()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "profileCellSegue" {
            let cell = sender as! ProfileDetailCollectionViewCell
            let indexPath = postsCollectionView.indexPath(for: cell)
            if let indexPath = indexPath {
                let post = postArray[indexPath.row]
                let destination = segue.destination as! PostDetailViewController
                destination.selectedPost = post
            }
        }
    }
    
    
}
