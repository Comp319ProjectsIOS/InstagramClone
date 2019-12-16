//
//  PostDetailViewController.swift
//  InstagramApp
//
//  Created by Melih on 14.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postDescriptionLabel: UILabel!
    
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
        }
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
