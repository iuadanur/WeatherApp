//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 31.12.2023.
//

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let coord: WeatherCoord
    let weather: [WeatherDetail]
    let base: String
    let main: WeatherMain
    let visibility: Int
    let wind: WeatherWind
    let clouds: WeatherClouds
    let dt: Int
    let sys: WeatherSys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - WeatherCoord
struct WeatherCoord: Codable {
    let lon, lat: Double
}

// MARK: - WeatherDetail
struct WeatherDetail: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - WeatherMain
struct WeatherMain: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - WeatherClouds
struct WeatherClouds: Codable {
    let all: Int
}

// MARK: - WeatherWind
struct WeatherWind: Codable {
    let speed: Double
    let deg: Int
}

// MARK: - WeatherSys
struct WeatherSys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

