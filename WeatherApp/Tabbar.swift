//
//  ViewController.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 31.12.2023.
//

import UIKit

class Tabbar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let sunMaxImage = UIImage(systemName: "sun.max")
        let sunMaxFillImage = UIImage(systemName: "sun.max.fill")
        let starImage = UIImage(systemName: "star")
        let starFillImage = UIImage(systemName: "star.fill")
        let personImage = UIImage(systemName: "person.crop.circle")
        let personFillImage = UIImage(systemName: "person.crop.circle.fill")
        
        
        if let firstTabBarItem = tabBar.items?.first {
            firstTabBarItem.image = sunMaxImage?.withTintColor(UIColor.orange, renderingMode: .alwaysOriginal)
            firstTabBarItem.selectedImage = sunMaxFillImage?.withTintColor(UIColor.orange, renderingMode: .alwaysOriginal)
            firstTabBarItem.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: UIColor.orange
            ], for: .normal)
            
            
        }

        
        if let secondTabBarItem = tabBar.items?[1] {
            secondTabBarItem.image = starImage?.withTintColor(UIColor.systemYellow, renderingMode: .alwaysOriginal)
            secondTabBarItem.selectedImage = starFillImage?.withTintColor(UIColor.systemYellow, renderingMode: .alwaysOriginal)
            secondTabBarItem.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: UIColor.systemYellow
            ], for: .normal)
        }

        if let thirdTabBarItem = tabBar.items?[2] {
            thirdTabBarItem.image = personImage?.withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
            thirdTabBarItem.selectedImage = personFillImage?.withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
            thirdTabBarItem.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: UIColor.black
            ], for: .normal)
        }
        
        
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
