//
//  collectionViewCell.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 6.02.2024.
//

import UIKit

class collectionViewCell: UICollectionViewCell {

    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var degreeLabel: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
    }
    
    func configure(with hourlyList: HourlyList) {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: hourlyList.dtTxt) {
            dateFormatter.dateFormat = "HH:mm"
            let hour = dateFormatter.string(from: date)
            clockLabel.text = hour
        } else {
            clockLabel.text = "--"
        }
        degreeLabel.text = "\(hourlyList.main.temp) °C"
        imageView.image = UIImage(named: hourlyList.weather.first?.icon ?? "01d")
    }

}
