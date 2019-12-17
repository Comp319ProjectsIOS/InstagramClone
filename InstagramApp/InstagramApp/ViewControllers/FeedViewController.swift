//
//  FeedViewController.swift
//  InstagramApp
//
//  Created by Melih on 14.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import UIKit

extension FeedViewController: FirebaseUtilitiesDelegate {
    func postDataFetched(postList: [Post]) {
        self.postArray = postList
        self.feedTableView.reloadData()
    }
}

extension FeedViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! FeedTableViewCell
        let post = postArray[indexPath.row]
        cell.postImageView.downloadImage(from: URL(string: post.urlToPostImage!)!)
        cell.usernameLabel.text = post.username
        cell.descriptionLabel.text = post.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Posts"
    }
}

class FeedViewController: UIViewController {
    @IBOutlet weak var feedTableView: UITableView!
    let firebaseUtilities = FirebaseUtilities.getInstance()
    var postArray: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseUtilities.fetchUsers()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseUtilities.delegate = self
        parent?.title = "Feed"
        
    }
    
//    @IBAction func refreshTapped(_ sender: Any) {
//        firebaseUtilities.fetchUsers()
//    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let cell = sender as! FeedTableViewCell
        let indexPath = feedTableView.indexPath(for: cell)
        if let indexPath = indexPath {
            let post = postArray[indexPath.row]
            let destination = segue.destination as! PostDetailViewController
            destination.selectedPost = post
        }
    }
}
