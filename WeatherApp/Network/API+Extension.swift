//
//  API+Extension.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 28.01.2024.
//

import Foundation

//MARK: - API Extension
extension API {
    static let baseUrlString = "https://api.openweathermap.org/data/2.5/"
    
    static func getUrlForWeather(lat: Double, lon: Double) -> String {
        return "\(baseUrlString)weather?lat=\(lat)&lon=\(lon)&appid=\(API_KEY)&units=metric"
    }
    static func getUrlForHourly(lat: Double, lon: Double) -> String {
        return "\(baseUrlString)forecast?lat=\(lat)&lon=\(lon)&appid=\(API_KEY)&units=metric"
    }
}
