//
//  AddCommentViewController.swift
//  InstagramApp
//
//  Created by Melih on 17.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import UIKit

extension AddCommentViewController: FirebaseUtilitiesDelegate{
    func dismissPage() {
        self.dismiss(animated: true, completion: nil)
    }
    func presentAlert(title: String, message: String) {
        presentAlertHelper(self, title: title, message: message)
    }
}

class AddCommentViewController: UIViewController {
    @IBOutlet weak var commentTextView: UITextView!
    
    var selectedPost: Post?
    let firebaseUtilities = FirebaseUtilities.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Comment"
        firebaseUtilities.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseUtilities.delegate = self
    }
    
    @IBAction func postCommentTapped(_ sender: Any) {
        guard let comment = commentTextView.text, !comment.isEmpty else {
            presentAlertHelper(self, title: "Error", message: "Please enter a comment")
            return
        }
        if let post = selectedPost {
            if let postId = post.postId {
                firebaseUtilities.addComment(postId: postId, comment: comment)
            }
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
