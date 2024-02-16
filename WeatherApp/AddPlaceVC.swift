//
//  AddPlace.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 26.12.2023.
//

import UIKit

class AddPlaceVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var CityTextField: UITextField!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = UIColor.white
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
    }
    
    @objc func selectImage(){
        
    }
    
    @IBAction func uploadButtonClicked(_ sender: Any) {
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
