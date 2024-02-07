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
    
    let weatherViewModel = WeatherViewModel.shared
    var hourlyList: [HourlyList] = []
    var hourlyWeather: [HourlyWeather] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.clear
    }
    
    
    func configure(with hourlyList: HourlyList) {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: hourlyList.dtTxt) {
            dateFormatter.dateFormat = "HH" // Sadece saat kısmını almak için formatı değiştiriyoruz
            let hour = dateFormatter.string(from: date)
            clockLabel.text = hour
        } else {
            clockLabel.text = "--" // Saat bilgisi yoksa, saat etiketini boş bırakabiliriz veya başka bir varsayılan değer atayabiliriz
        }
        
        degreeLabel.text = "\(hourlyList.main.temp) °C"
        imageView.image = UIImage(named: hourlyList.weather.first?.icon ?? "01d")
    }

}
