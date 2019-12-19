//
//  CommentsViewController.swift
//  InstagramApp
//
//  Created by Melih on 17.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import UIKit

extension CommentsViewController: FirebaseUtilitiesDelegate{
    func commentsForPostFetched(commentList: [Comment]) {
        commentsArray = commentList
        self.commentsTableView.reloadData()
    }
    func presentAlert(title: String, message: String) {
        presentAlertHelper(self, title: title, message: message)
    }
}

extension CommentsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! CommentsTableViewCell
        let comment = commentsArray[indexPath.row]
        cell.commentLabel.text = comment.comment
        cell.usernameLabel.text = comment.username
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Comments"
    }
}

class CommentsViewController: UIViewController {
    @IBOutlet weak var commentsTableView: UITableView!
    var selectedPost: Post?
    let firebaseUtilities = FirebaseUtilities.getInstance()
    var commentsArray = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Comments"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseUtilities.delegate = self
        getComments()
    }
    
    func getComments() {
        if let post = self.selectedPost {
            if let postId = post.postId {
                firebaseUtilities.fetchComments(postId: postId)
            }
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
