//
//  ProfileVC.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 26.12.2023.
//

import UIKit
import FirebaseAuth
class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func LogoutClicked(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            performSegue(withIdentifier: "fromProfiletoWelcome", sender: nil)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    

}
