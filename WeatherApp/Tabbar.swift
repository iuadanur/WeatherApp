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

        
        customizeTabBar()
        
    }
    
    func customizeTabBar(){
        let sunMaxImage = UIImage(systemName: "sun.max")
        let sunMaxFillImage = UIImage(systemName: "sun.max.fill")
        let photoImage = UIImage(systemName: "photo")
        let photoFillImage = UIImage(systemName: "photo.fill")
        let personImage = UIImage(systemName: "person.crop.circle")
        let personFillImage = UIImage(systemName: "person.crop.circle.fill")
        
        
        if let firstTabBarItem = tabBar.items?.first {
            firstTabBarItem.image = sunMaxImage?.withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
            firstTabBarItem.selectedImage = sunMaxFillImage?.withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
            firstTabBarItem.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: UIColor.black
            ], for: .normal)
            
            
        }

        
        if let secondTabBarItem = tabBar.items?[1] {
            secondTabBarItem.image = photoImage?.withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
            secondTabBarItem.selectedImage = photoFillImage?.withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
            secondTabBarItem.setTitleTextAttributes([
                NSAttributedString.Key.foregroundColor: UIColor.black
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
