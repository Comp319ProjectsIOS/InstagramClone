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
    }
    func presentAlert(title: String, message: String) {
        presentAlertHelper(self, title: title, message: message)
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
        item.postImageView.downloadImage(from: URL(string: post.urlToPostImage!)!)
        return item
    }
    
    
}


class ProfileDetailViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postsCollectionView: UICollectionView!
    var selectedUser: User?
    let firebaseUtilities = FirebaseUtilities.getInstance()
    var postArray: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseUtilities.delegate = self
        title = "Profile Detail"
        if let user = selectedUser {
            usernameLabel.text = user.userName
            profileImageView.downloadImage(from: URL(string: user.imageRef!)!)
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseUtilities.delegate = self
    }
    
    @IBAction func addFriendTapped(_ sender: Any) {
        firebaseUtilities.addFriend(user: selectedUser)
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
