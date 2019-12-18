//
//  HelpScreenViewController.swift
//  InstagramApp
//
//  Created by Başak Çörtük on 17.12.2019.
//  Copyright © 2019 BasakMelih. All rights reserved.
//

import UIKit

extension HelpScreenViewController: FirebaseUtilitiesDelegate {
    func presentAlert(title: String, message: String) {
        presentAlertHelper(self, title: title, message: message)
    }
    func dismissPage(){
        let vc = self.storyboard?.instantiateViewController(identifier: "loginVC")
        self.navigationController?.viewControllers = [vc!]
    }
}
class HelpScreenViewController: UIViewController {
    
    let firebaseUtilities = FirebaseUtilities.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parent?.title = "Help Screen"
         firebaseUtilities.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        firebaseUtilities.signOut()
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
