//
//  HourlyModel.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 28.01.2024.
//

import Foundation

// MARK: - HourlyModel
struct HourlyModel: Codable {
    let cod: String
    let message,cnt: Int
    let list: [HourlyList]
    let city: HourlyCity
}

// MARK: - City
struct HourlyCity: Codable {
    let id: Int
    let name: String
    let coord: HourlyCoord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct HourlyCoord: Codable {
    let lat, lon: Double
}

// MARK: - List
struct HourlyList: Codable {
    let dt: Int
    let main: HourlyClass
    let weather: [HourlyWeather]
    let clouds: HourlyClouds
    let wind: HourlyWind
    let visibility: Int
    let sys: HourlySys
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
struct HourlyClouds: Codable {
    let all: Int
}

// MARK: - MainClass
struct HourlyClass: Codable {
    let temp, feelsLike, tempMin, tempMax, tempKf: Double
    let pressure, seaLevel, grndLevel, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Sys
struct HourlySys: Codable {
    let pod: String
}


// MARK: - Weather
struct HourlyWeather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - Wind
struct HourlyWind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}
