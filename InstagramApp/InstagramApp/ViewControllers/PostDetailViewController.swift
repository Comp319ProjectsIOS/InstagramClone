//
//  PostDetailViewController.swift
//  InstagramApp
//
//  Created by Melih on 14.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import UIKit
extension PostDetailViewController: FirebaseUtilitiesDelegate {
    
}

class PostDetailViewController: UIViewController {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    @IBOutlet weak var usernameButton: UIButton!
    let firebaseUtilities = FirebaseUtilities.getInstance()
    var selectedPost: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post Details"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if let post = selectedPost {
            postImage.downloadImage(from: URL(string: post.urlToPostImage!)!)
            postDescriptionLabel.text = post.description
            usernameButton.setTitle(post.username, for: .normal)
        }
        firebaseUtilities.delegate = self
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "profileDetailSegue" {
            if let post = self.selectedPost {
                let destination = segue.destination as! ProfileDetailViewController
                if let userId = post.uid {
                    if let userData = firebaseUtilities.userDict["\(userId)"] as? [String : Any]{
                        var user = User()
                        if let username = userData["userName"] as? String, let urlToImage = userData["urlToImage"] as? String, let uid = userData["uid"] as? String {
                            user.imageRef = urlToImage
                            user.uid = uid
                            user.userName = username
                        }
                        destination.selectedUser = user
                        firebaseUtilities.fetchPostsForProfile(uid: userId)
                    }
                    
                }
            }
        } else if segue.identifier == "addCommentSegue" {
            if let post = self.selectedPost {
                let destination = segue.destination as! AddCommentViewController
                destination.selectedPost = post
            }
            
        }
    }
}




