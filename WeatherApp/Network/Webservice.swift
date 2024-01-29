//
//  Webservice.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 31.12.2023.
//

import Foundation

enum WeatherError : Error {
    case serverError
    case parsingError
}

final class Webservice<T: Codable>{
    
    func fetchData(url: URL, completion: @escaping (Result<T,WeatherError>) -> ()){
        
        URLSession.shared.dataTask(with: url) { data , response, error in
            if let _ = error {
                completion(.failure(.serverError))
            }else if let data = data {
                do {
                    let json = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(json))
                } catch {
                    completion(.failure(.parsingError))
                }
            }
        }.resume()
    }
}
