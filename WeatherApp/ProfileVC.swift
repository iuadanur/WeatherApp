//
//  ProfileVC.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 26.12.2023.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileVC: UIViewController {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var joinedLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoritePostsLabel: UILabel!
    
    private var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseUserModel()
        navigationBarCustomization()
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View will appear, updating user info...")
        updateUserInfo()
        getPosts()
    }
    
    func updateUserInfo() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" // Dönüştürmek istediğiniz tarih biçimi

        if let currentUser = Auth.auth().currentUser {
            let userId = currentUser.uid
            let userDocRef = Firestore.firestore().collection("users").document(userId)

            userDocRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let username = document["username"] as? String {
                        self.usernameLabel.text = username
                    }
                    if let userImage = self.profileImage.image {
                        if let userImageURLString = document["userImageURL"] as? String,
                           let userImageURL = URL(string: userImageURLString) {
                            // URL'yi kullanarak resmi indir
                            URLSession.shared.dataTask(with: userImageURL) { (data, response, error) in
                                // Hata kontrolü
                                if let error = error {
                                    print("Resim indirme hatası: \(error.localizedDescription)")
                                    return
                                }
                                // Veri kontrolü ve resmi oluşturma
                                if let data = data, let userImage = UIImage(data: data) {
                                    // Ana ekranda kullanıcı resmini gösterme
                                    DispatchQueue.main.async {
                                        self.profileImage.image = userImage
                                    }
                                } else {
                                    print("Resim verisi boş veya hatalı")
                                }
                            }.resume()
                        } else {
                            print("userImageURL dizesi alınamadı veya dönüştürülemedi")
                        }

                    }
                } else {
                    print("Kullanıcı belgesi bulunamadı.")
                }
            }

            if let date = currentUser.metadata.creationDate {
                joinedLabel.text = "Joined \(dateFormatter.string(from: date))"
            }
        }
    }
    
    func firebaseUserModel() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Kullanıcı kimliği bulunamadı.")
            return
        }

        let userDocRef = Firestore.firestore().collection("users").document(userId)

        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Kullanıcı modeli zaten oluşturulmuş.")
            } else {
                // Kullanıcı modeli oluştur
                let defaultImage = self.getDefaultProfileImage() // Varsayılan profil resmi alınıyor
                userDocRef.setData([
                    "username": Auth.auth().currentUser!.email!, // Varsayılan kullanıcı adı
                    "userImage": defaultImage, // Varsayılan profil resmi
                    // Diğer kullanıcı özellikleri buraya eklenebilir
                ]) { error in
                    if let error = error {
                        print("Kullanıcı belgesi oluşturulurken hata oluştu: \(error)")
                    } else {
                        print("Kullanıcı belgesi başarıyla oluşturuldu.")
                    }
                }
            }
        }
    } 
    func getPosts() {
        
        let db = Firestore.firestore()
        
        db.collection("Posts").whereField("postedBy", isEqualTo: Auth.auth().currentUser?.email! as Any).whereField("isFavorite", isEqualTo: true).getDocuments { snapshot, error in
            
            if error != nil {
                print("\(String(describing: error))")
            } else {
                guard let snapshot = snapshot else {
                    print("Snapshot is nil")
                    return
                }
                
                self.posts = snapshot.documents.compactMap { document in
                    let data = document.data()
                    let location = data["location"] as? String ?? ""
                    let imageUrl = data["imageUrl"] as? String ?? ""
                    let isFavorite = data["isFavorite"] as? Bool ?? false
                    let postComment = data["postComment"] as? String ?? ""
                    let postedBy = data["postedBy"] as? String ?? ""
                    let timestamp = data["date"] as? Timestamp
                    // Timestamp'i string formata dönüştür
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy" // veya istediğiniz bir format
                    let formattedDate = dateFormatter.string(from: timestamp?.dateValue() ?? Date()) // Date? değeri String'e dönüştürülüyor
                    let documentId = document.documentID
                    
                    return Post(imageUrl: imageUrl, isFavorite: isFavorite, postComment: postComment, postedBy: postedBy, location: location, postedTime: formattedDate, documentId: documentId)
                
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
            
        
    }
    func getDefaultProfileImage() -> String? {
        // Varsayılan profil resmini almak için uygun bir yol buraya ekleyin
        // Örneğin, bir resim URL'si veya resmin adı gibi
        // Burada sadece örnek bir değer döndürüyorum
        return "person.circle"
    }

    
    func navigationBarCustomization(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonClicked))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshInfo))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    @objc func refreshInfo() {
        updateUserInfo()
        getPosts()
    }
    @IBAction func editProfileTapped(_ sender: Any) {
        performSegue(withIdentifier: "toEditProfileVC", sender: nil)
    }
    
    
    @objc func logoutButtonClicked() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            performSegue(withIdentifier: "fromProfiletoWelcome", sender: nil)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    

}
//MARK: - TableView
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        cell.configure(with: post)
        return cell
    }
    
    
}
