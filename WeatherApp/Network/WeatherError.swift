//
//  WeatherError.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 4.02.2024.
//

import Foundation

enum WeatherError : Error {
    case serverError
    case parsingError
    case locationNotFound
    case geocodingError
    case invalidURL
    case locationNotAvailable
}
