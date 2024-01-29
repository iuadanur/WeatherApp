//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 28.01.2024.
//

import Foundation

struct WeatherResponse: Codable {
    
    let currentWeather: WeatherModel
    let hourlyWeather: HourlyModel
    
}
