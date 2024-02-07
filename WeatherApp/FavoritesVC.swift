//
//  FavoritesVC.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 26.12.2023.
//

import UIKit

class FavoritesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "FavoriteCell", bundle: nil), forCellReuseIdentifier: "favoriteCell")
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(addButtonClicked))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        
        
        
    }
    @objc func addButtonClicked(){
        self.performSegue(withIdentifier: "toAddPlace", sender: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        

    }
}

extension FavoritesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell") as! FavoriteCell
            cell.titleLabel.text = "deneme"
            cell.cellView.backgroundColor = .blue
            return cell
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
