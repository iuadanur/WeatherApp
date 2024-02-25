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
    
    var refreshControl = UIRefreshControl()
    let weatherViewModel = WeatherViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CityCell", bundle: nil), forCellReuseIdentifier: "cityCell")
        tableView.register(UINib(nibName: "SearchBarCell", bundle: nil), forCellReuseIdentifier: "searchBarCell")
        tableView.register(UINib(nibName: "HourlyCell", bundle: nil), forCellReuseIdentifier: "hourlyCell")
        tableView.backgroundColor = UIColor.clear
        tableView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(refreshWeatherData), for: .valueChanged)
        setupTabbar()
        fetchDataAndUpdateUI()
        
    }
    @objc func refreshWeatherData(_ sender: Any) {
        fetchDataAndUpdateUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.refreshControl.endRefreshing()
        }
    }
    
    func setupTabbar() {
        tabBarController?.tabBar.backgroundColor = .white.withAlphaComponent(0.8)
    }
    
    func fetchDataAndUpdateUI() {
        weatherViewModel.fetchData { result in
            switch result {
            case .success:
                print("Weather data fetched successfully")
                // WeatherModel verileri çekildikten sonra UI güncelleme
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.updateUI()
                }
            case .failure(let error):
                print("Fetch weather data error: \(error)")
            }
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
            let icon = WeatherModel.weather.first?.icon ?? "01d"
            for weatherInfo in WeatherModel.weather {
                    //id = weatherInfo.id
                    main = weatherInfo.description
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
                    cell.weatherIcon.image = UIImage(named: icon)
                }
            }
        }
        if let hourlyModel = weatherViewModel.hourlyWeatherModel {
            if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? HourlyCell {
                cell.collectionView.reloadData()
            }
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "searchBarCell", for: indexPath) as! SearchBarCell
                    cell.backgroundColor = UIColor.clear
                    cell.delegate = self
                    cell.searchBar.placeholder = "Search for city..."
                    return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath) as! CityCell
                cell.backgroundColor = UIColor.clear
                updateUI()
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "hourlyCell", for: indexPath) as! HourlyCell
                cell.backgroundColor = UIColor.clear
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
            return 270
        case 2:
            return 195
        default:
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        backgroundImage.isHidden = false
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
}

//MARK: - SearchBarCellDelegate
extension WeatherVC: SearchBarCellDelegate {
    func searchBarCell(_ cell: SearchBarCell, didTapSearchButtonWith searchTerm: String) {
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
