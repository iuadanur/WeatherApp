//
//  RegisteredVC.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 24.12.2023.
//

import UIKit

class RegisteredVC: UIViewController {

    @IBOutlet weak var okImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.navigationBar.isHidden = true
        backButtonCustomize()
    }
    @IBAction func buttonClicked(_ sender: Any) {
        performSegue(withIdentifier: "fromRegisteredtoWelcome", sender: nil)
    }
    func backButtonCustomize(){
        backButton.layer.cornerRadius = 15
        backButton.layer.borderWidth = 2
        backButton.layer.borderColor = UIColor.white.cgColor
        view.addSubview(backButton)
    }
}
