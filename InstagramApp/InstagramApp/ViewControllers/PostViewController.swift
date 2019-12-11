//
//  PostViewController.swift
//  InstagramApp
//
//  Created by Melih on 5.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    @IBOutlet weak var postDescriptionLabel: UITextField!
    @IBOutlet weak var postImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func postTapped(_ sender: Any) {
    }
    
    @IBAction func selectImageTapped(_ sender: Any) {
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
