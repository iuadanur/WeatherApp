//
//  WeatherVC.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 25.12.2023.
//

import UIKit
import CoreLocation

class WeatherVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    let weatherViewModel = WeatherViewModel<WeatherModel>()
    let hourlyViewModel = WeatherViewModel<HourlyModel>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CityCell", bundle: nil), forCellReuseIdentifier: "cityCell")
        tableView.register(UINib(nibName: "SearchBarCell", bundle: nil), forCellReuseIdentifier: "searchBarCell")
        tableView.backgroundColor = UIColor.clear
        setupTabbar()
        
        fetchDataAndUpdateUI()
        
    }
    
    func setupTabbar() {
        tabBarController?.tabBar.backgroundColor = .white.withAlphaComponent(0.8)
    }
    /*
    func fetchDataAndUpdateUI() {
        weatherViewModel.fetchData { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.updateUI()
                }
            case .failure(let error):
                print("Fetch data error: \(error)")
                // Hata durumunda gerekirse ek işlemler yapabilirsiniz.
            }
        }
    } */
    func fetchDataAndUpdateUI() {
        let dispatchGroup = DispatchGroup()
        
        // WeatherModel verilerini çek
        dispatchGroup.enter()
        weatherViewModel.fetchData { result in
            switch result {
            case .success:
                print("Weather data fetched successfully")
            case .failure(let error):
                print("Fetch weather data error: \(error)")
            }
            dispatchGroup.leave()
        }
        
        // HourlyModel verilerini çek
        dispatchGroup.enter()
        hourlyViewModel.fetchData { result in
            switch result {
            case .success:
                print(result)
                print("Hourly data fetched successfully")
            case .failure(let error):
                print("Fetch hourly data error: \(error)")
            }
            dispatchGroup.leave()
        }
        
        // Her iki veri türünün de çekilmesini bekleyin ve UI güncellemesini yapın
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
            self.updateUI()
        }
    }

    func updateUI() {
        
        if let WeatherModel = weatherViewModel.model {
            
            let cityName = WeatherModel.name
            let temperature = WeatherModel.main.temp
            let tempMin = WeatherModel.main.tempMin
            let tempMax = WeatherModel.main.tempMax
            //var id = 0
            var main = ""
            //var description = ""
            for weatherInfo in WeatherModel.weather {
                    //id = weatherInfo.id
                    main = weatherInfo.main
                    //description = weatherInfo.description
                    
                }
            
            DispatchQueue.main.async {
                // TableView'ın ilk hücresini güncelle
                if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? CityCell {
                    cell.cityNameLabel.text = cityName
                    cell.degreeLabel.text = "\(String(format: "%.1f", temperature))°C"
                    cell.tempMinLabel.text = "L:\(String(format: "%.f°", tempMin))"
                    cell.tempMaxLabel.text = "H:\(String(format: "%.f°", tempMax))"
                    cell.descriptionLabel.text = "\(main)"
                }
            }
            
            
        }
        if let hourlyModel = hourlyViewModel.model{
            
        }
        
    }
}
    //MARK: - Tableview Delegate&DataSource
    extension WeatherVC: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch indexPath.section {
                case 0:
                    // SearchBarCell oluştur
                    let cell = tableView.dequeueReusableCell(withIdentifier: "searchBarCell", for: indexPath) as! SearchBarCell
                    cell.backgroundColor = UIColor.clear
                    cell.delegate = self
                    // searchBarCell'i güncelle
                    // Örneğin:
                    // cell.searchBar.placeholder = "Search for city..."
                    return cell
                case 1:
                    // CityCell oluştur
                    let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityCell
                    // CityCell'i güncelle
                    cell.backgroundColor = UIColor.clear
                    updateUI()
                    return cell
                default:
                    fatalError("Unexpected section")
                }
            
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            switch indexPath.section{
            case 0:
                return 55
            case 1:
                return 185
            default:
                return 100
            }
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Hücreye tıklandığında arka plan fotoğrafını görünür yapın
            backgroundImage.isHidden = false

            // Diğer hücre tıklamalarını işleyebilir veya diğer işlemleri gerçekleştirebilirsiniz
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 2
        }
        
    }
extension WeatherVC: SearchBarCellDelegate {
    func searchBarCell(_ cell: SearchBarCell, didTapSearchButtonWith searchTerm: String) {
        // SearchBarCell'den alınan şehir ismini kullanarak koordinatları almak için bir işlem yapın
        //Buraya viewModel için bir fonksiyon çağırayım. Butona basıldığında şehrin verisini çeksin
        weatherViewModel.fetchCity { result in
            switch result {
            case .success:
                print("Weather data fetched successfully")
                self.updateUI()
            case .failure(let error):
                print("Fetch weather data error: \(error)")
            }
        }
        
    }
}
