//
//  FavoritesVC.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 26.12.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class PhotosVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var locations: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add , target: self, action: #selector(addButtonClicked))
        
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        title = "Photos"
        navigationController?.navigationBar.prefersLargeTitles = false
        getDataFromFirestore()
    }
    @objc func addButtonClicked(){
        self.performSegue(withIdentifier: "toAddPlace", sender: nil)
    }
    func getDataFromFirestore() {
        let db = Firestore.firestore()

        // Firestore'dan "post" koleksiyonundaki verileri alın
        db.collection("Posts").order(by: "location").getDocuments { (snapshot, error) in
            if let error = error {
                print("Veriler alınırken hata oluştu: \(error.localizedDescription)")
                return
            }
            guard let snapshot = snapshot else {
                    print("Snapshot is nil")
                    return
                }
            
            for document in snapshot.documents {
                guard Auth.auth().currentUser?.email == document.data()["postedBy"] as? String ?? "" else {print("It is not current user");continue}
                        
                let location = document.data()["location"] as? String ?? ""
                if !self.locations.contains(location) {
                    self.locations.append(location)
                }
                let imageUrl = document.data()["imageUrl"] as? String ?? ""
                let isFavorite = document.data()["isFavorite"] as? Bool ?? false
                let postComment = document.data()["postComment"] as? String ?? ""
                let postedBy = document.data()["postedBy"] as? String ?? ""
                // İşlenecek diğer verileri buraya ekleyin veya bir model nesnesi oluşturun
                print("Location: \(location), Image URL: \(imageUrl), Is Favorite: \(isFavorite), Comment: \(postComment), Posted By: \(postedBy)")
            }
            self.tableView.reloadData()
        }
    }
}

extension PhotosVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = locations[indexPath.row]
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
}
