//
//  WeatherVC.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 25.12.2023.
//

import UIKit

class WeatherVC: UIViewController {

    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
        let sunMaxImage = UIImage(systemName: "sun.max")
        let sunMaxFillImage = UIImage(systemName: "sun.max.fill")
        tabBarItem.image = sunMaxImage?.withTintColor(UIColor.orange, renderingMode: .alwaysOriginal)
        tabBarItem.selectedImage = sunMaxFillImage?.withTintColor(UIColor.orange, renderingMode: .alwaysOriginal)
    }
    
    func setupTabbar() {
        tabBarController?.tabBar.backgroundColor = .white.withAlphaComponent(0.8)
    }


}
