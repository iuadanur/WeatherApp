//
//  editProfileVC.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 12.02.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class editProfileVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var changeImage: UIImageView!
    
    @IBOutlet weak var usernameField: UITextField!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fillTextFields()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(backButtonTapped))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeImageTapped))
                changeImage.addGestureRecognizer(tapGesture)
    }
    
    func fillTextFields() {
        if let currentUser = Auth.auth().currentUser {
            let userId = currentUser.uid
            let userDocRef = Firestore.firestore().collection("users").document(userId)

            userDocRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let username = document["username"] as? String {
                        self.usernameField.text = username
                    }
                } else {
                    print("Kullanıcı belgesi bulunamadı.")
                }
            }
        }
    }
    
    @objc func changeImageTapped() {
            // Fotoğraf seçme veya çekme işlemi için kullanıcıya seçenek sun
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.openCamera()
            }))
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                self.openGallery()
            }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true)
    }
    
    @objc func backButtonTapped(){
        self.dismiss(animated: true)
    }
    
    func openGallery() {
        imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true)
    }
    
    func openCamera() {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                present(imagePicker, animated: true)
            } else {
                print("Camera is not available")
            }
        }
    func uploadImage(_ image: UIImage) {
        // Fotoğrafı Firebase Storage'a yükleyin ve URL'sini saklayın
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let imageName = UUID().uuidString
        let imageRef = Storage.storage().reference().child("images/\(imageName)")

        imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard let _ = metadata else {
                print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                // Yükleme başarılı, URL'i saklayın
                self.saveUserImageURL(downloadURL.absoluteString)
            }
        }
    }

    func saveUserImageURL(_ imageURL: String) {
        // Kullanıcının fotoğraf URL'sini Firestore veritabanına kaydedin
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User ID not found")
            return
        }
        let userDocRef = Firestore.firestore().collection("users").document(userId)
        userDocRef.updateData(["userImageURL": imageURL]) { error in
            if let error = error {
                print("Error updating user image URL: \(error.localizedDescription)")
            } else {
                print("User image URL saved successfully")
            }
        }
    }
    // Kullanıcının seçtiği fotoğrafı aldığımızda çağrılır
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[.editedImage] as? UIImage {
                changeImage.image = pickedImage
            }
            dismiss(animated: true)
    }

        // Kullanıcı fotoğraf seçmeyi iptal ettiğinde çağrılır
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true)
    }
    @IBAction func saveChangesClicked(_ sender: Any) {
        
        guard let newUsername = usernameField.text, !newUsername.isEmpty else {
            // Kullanıcı adı alanının boş olmadığını doğrulayın
            print("Kullanıcı adı boş olamaz")
            return
        }
        if newUsername != "" {
            // Yeni kullanıcı adının benzersiz olup olmadığını kontrol edin
            isUsernameAvailable(newUsername) { available in
                if available {
                    // Yeni kullanıcı adı benzersiz, kullanıcı profiline kaydedin
                    self.updateUsername(newUsername)
                } else {
                    // Yeni kullanıcı adı zaten kullanımda, kullanıcıya uyarı verin
                    print("Kullanıcı adı zaten kullanımda")
                }
            }
        }
        if let image = changeImage.image, let tappedToChangeImage = UIImage(named: "tapToChangeImage.png"),
           let imageData = tappedToChangeImage.pngData(), let selectedImageData = image.pngData(), selectedImageData != imageData {
            uploadImage(image)
        } else {
            print("Profil resmi değiştirilmedi")
        }



        
        self.dismiss(animated: true)
    }
    
    func isUsernameAvailable(_ username: String, completion: @escaping (Bool) -> Void) {
            let usersRef = Firestore.firestore().collection("users")
            let query = usersRef.whereField("username", isEqualTo: username)
            
            query.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Kullanıcı adı kontrolü sırasında hata oluştu: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    completion(true) // Belge yoksa, kullanıcı adı mevcut değil
                    return
                }
                
                // Eğer dökümanlar varsa, kullanıcı adı zaten kullanılmış demektir
                completion(documents.isEmpty)
            }
        }
        
    func updateUsername(_ newUsername: String) {
            guard let userId = Auth.auth().currentUser?.uid else {
                print("Kullanıcı kimliği bulunamadı.")
                return
            }
            
            let userDocRef = Firestore.firestore().collection("users").document(userId)
            
            userDocRef.updateData(["username": newUsername]) { error in
                if let error = error {
                    print("Kullanıcı adı güncellenirken hata oluştu: \(error.localizedDescription)")
                } else {
                    print("Kullanıcı adı başarıyla güncellendi")
                    // Profil ekranına geri dön veya başka bir işlem yap
                }
            }
        }
}
