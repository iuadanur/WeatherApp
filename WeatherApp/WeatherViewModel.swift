//
//  ViewModel.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 31.12.2023.
//

import Foundation
import CoreLocation

enum VMError : Error{
    case locationNotAvailable
    case invalidURL
    
}

class WeatherViewModel<T: Codable> : NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var weatherResponseModel: WeatherResponse?
    var model: T?
    var hourlyWeatherModel: T?
    let geocoder = CLGeocoder()
    
    private var locationManager = CLLocationManager()

    override init() {
            // Konum yöneticisi (location manager) konum değişikliklerini takip edecek şekilde ayarlanıyor.
            super.init()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    /*
    @Published var city : String = "Istanbul" {
        didSet{
            getLocation()
        }
    }
    
    func getLocation(){
        CLGeocoder().geocodeAddressString(city) {(placemarks,error) in
            if let places = placemarks, let place = places.first{
                self.getWeather(coord: place.location?.coordinate)
                self.getHourlyWeather(coord: place.location?.coordinate)
            }
        }
    }
    private func getWeather(coord: CLLocationCoordinate2D?){
        if let coord = coord {
            let urlString = API.getUrlForWeather(lat: coord.latitude, lon: coord.longitude)
            getWeatherInternal(city: city, for: urlString)
        }else {
            let urlString = API.getUrlForWeather(lat: 40.99, lon: 39.72)
            getWeatherInternal(city: city, for: urlString)
        }
    }
    private func getHourlyWeather(coord: CLLocationCoordinate2D?){
        if let coord = coord {
            let urlString = API.getUrlForHourly(lat: coord.latitude, lon: coord.longitude)
            getHourlyWeatherInternal(city: city, for: urlString)
        }else {
            let urlString = API.getUrlForWeather(lat: 40.99, lon: 39.72)
            getHourlyWeatherInternal(city: city, for: urlString)
        }
    }
    
    private func getHourlyWeatherInternal(city: String, for urlString: String){
        Webservice<HourlyModel>.fetchData(url: URL(string: urlString)!) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    strongSelf.hourlyWeatherModel = model
                }
            case .failure(let error):
                print("Hourly API error: \(error)")
            }
        }
    }
    private func getWeatherInternal(city: String, for urlString: String){
        Webservice<WeatherResponse>.fetchData(url: URL(string: urlString)!) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    strongSelf.hourlyWeatherModel = model.hourlyWeather
                    strongSelf.weatherModel = model.currentWeather
                }
            case .failure(let error):
                print("Weather API error: \(error)")
            }
        }
    }
    */
    func fetchCity(completion: @escaping (Result<Void, Error>) -> Void){
        
        
        geocoder.geocodeAddressString(city.shared.name) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            guard let placemark = placemarks?.first, let location = placemark.location else {
                print("Location not found")
                return
            }
            
            // Koordinatları kullanarak WeatherViewModel'dan hava durumu verilerini almak için bir işlem yapın
            let urlString = API.getUrlForWeather(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                    guard let url = URL(string: urlString) else {
                        completion(.failure(VMError.invalidURL))
                        return
                    }
            Webservice<T>.fetchData(url: url) { result in
                switch result {
                case .success(let weatherModel):
                    print(weatherModel)
                    self.model = weatherModel
                    completion(.success(()))
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
        }
    }
    func fetchData(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentLocation = locationManager.location else {
            completion(.failure(VMError.locationNotAvailable))
                    return
                }
        let urlString = API.getUrlForWeather(lat: currentLocation.coordinate.latitude, lon: currentLocation.coordinate.longitude)
                guard let url = URL(string: urlString) else {
                    completion(.failure(VMError.invalidURL))
                    return
                }
        Webservice<T>.fetchData(url: url) { result in
            switch result {
            case .success(let weatherModel):
                print(weatherModel)
                self.model = weatherModel
                completion(.success(()))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
}
