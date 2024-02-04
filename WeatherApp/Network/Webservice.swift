//
//  Webservice.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 31.12.2023.
//

import Foundation

final class Webservice {
    
    static let shared = Webservice()
    
    private init(){}
    
    func fetchData<T: Codable>(url: URL, completion: @escaping (Result<T, WeatherError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.serverError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.serverError))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                print(String(describing: error))
                completion(.failure(.parsingError))
            }
        }.resume()
    }
}
