//
//  ViewModel.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 31.12.2023.
//

import Foundation
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let shared = WeatherViewModel()
    var model: WeatherModel?
    var hourlyWeatherModel: HourlyModel?
    let geocoder = CLGeocoder()
    
    private var locationManager = CLLocationManager()
    private var webservice = Webservice.shared
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func fetchCity(completion: @escaping (Result<Void, Error>) -> Void){
        getLocation { result in
            switch result {
            case .success(let location):
                self.fetchDataAtLocation(location, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchData(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentLocation = locationManager.location else {
            completion(.failure(WeatherError.locationNotAvailable))
            return
        }
        fetchDataAtLocation(currentLocation, completion: completion)
    }
    
    private func getLocation(completion: @escaping (Result<CLLocation, Error>) -> Void) {
        geocoder.geocodeAddressString(City.shared.name) { [weak self] (placemarks, error) in
            guard self != nil else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let placemark = placemarks?.first, let location = placemark.location else {
                completion(.failure(WeatherError.locationNotFound))
                return
            }
            completion(.success(location))
        }
    }
    
    private func fetchDataAtLocation(_ location: CLLocation, completion: @escaping (Result<Void, Error>) -> Void) {
        let urlWeather = API.getUrlForWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        guard let urlWeather = URL(string: urlWeather) else {
            completion(.failure(WeatherError.invalidURL))
            return
        }
        
        let urlHourly = API.getUrlForHourly(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        guard let urlHourly = URL(string: urlHourly) else {
            completion(.failure(WeatherError.invalidURL))
            return
        }
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        // Fetch WeatherModel
        webservice.fetchData(url: urlWeather) { (result: Result<WeatherModel, WeatherError>) in
            switch result {
            case .success(let weatherModel):
                print(weatherModel)
                self.model = weatherModel
            case .failure(let error):
                completion(.failure(error))
            }
            dispatchGroup.leave()
        }
        // Fetch HourlyModel
        dispatchGroup.enter()
        webservice.fetchData(url: urlHourly) { (result: Result<HourlyModel, WeatherError>) in
            switch result {
            case .success(let hourlyWeatherModel):
                print(hourlyWeatherModel)
                self.hourlyWeatherModel = hourlyWeatherModel
            case .failure(let error):
                completion(.failure(error))
            }
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            completion(.success(()))
        }
    }
}
