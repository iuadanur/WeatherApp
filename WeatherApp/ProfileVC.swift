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
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  firebaseUserModel()
        navigationBarCustomization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View will appear, updating user info...")
        updateUserInfo()
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
    
/*    func firebaseUserModel() {
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
    } */

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
