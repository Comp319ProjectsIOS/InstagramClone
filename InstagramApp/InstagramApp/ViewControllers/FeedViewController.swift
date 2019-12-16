//
//  FeedViewController.swift
//  InstagramApp
//
//  Created by Melih on 14.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import UIKit

extension FeedViewController: FirebaseUtilitiesDelegate {
    
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
        let index = indexPath.row.quotientAndRemainder(dividingBy: 5).remainder
        let player = postArray[indexPath.row]
//        cell.postImageView.image
//        cell.usernameLabel.text
  //      cell.descriptionLabel.text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Posts"
    }
}

class FeedViewController: UIViewController {
    @IBOutlet weak var feedTableView: UITableView!
    let firebaseUtilities = FirebaseUtilities()
    let postArray: [Post] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseUtilities.delegate = self
        firebaseUtilities.fetchUsers()
        // Do any additional setup after loading the view.
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
