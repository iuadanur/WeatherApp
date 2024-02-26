//
//  AddPlace.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 26.12.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class AddPlaceVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var darkImage: UIImageView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .white
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        imagePicker.delegate = self
    }
    
    @objc func selectImage(){
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
    
    @IBAction func uploadButtonClicked(_ sender: Any) {
        
        if let tapToUploadImage = UIImage(named: "tapToUploadImage.png"), let image = imageView.image, let imageData = tapToUploadImage.pngData(), let selectedImageData = image.pngData(), selectedImageData == imageData {
            self.makeAlert(titleInput: "ERROR", messageInput: "Please upload photo")
        }else {
            guard locationTextField.text != "" else {
                makeAlert(titleInput: "ERROR", messageInput: "Please enter a location")
                return
            }
            guard commentTextField.text != "" else {
                makeAlert(titleInput: "ERROR", messageInput: "Please enter a comment")
                return
            }

            let storage = Storage.storage()
            let storageReference = storage.reference()
            
            let mediaFolder = storageReference.child("media")
            
            if let data = imageView.image?.jpegData(compressionQuality: 0.5){
                
                let uuid = UUID().uuidString
                let imageReference = mediaFolder.child("\(uuid).jpg")
                
                imageReference.putData(data) { metadata, error in
                    if error != nil {
                        self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Unknown Error")
                    }else {
                        imageReference.downloadURL { url, error in
                            guard error == nil else {return self.makeAlert(titleInput: "ERROR", messageInput: error?.localizedDescription ?? "Unknown Error")}
                            
                            let imageUrl = url?.absoluteString
                            
                            //DATABASE
                            let firestore = Firestore.firestore()
                            guard let currentUserID = Auth.auth().currentUser?.uid else {return}
                            
                            var firestoreReference: DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl":imageUrl!,"postedBy": Auth.auth().currentUser!.email!,"date": FieldValue.serverTimestamp(),"postComment":self.commentTextField.text!,"location": self.locationTextField.text!,"isFavorite":false] as [String : Any]
                            firestoreReference = firestore.collection("Posts").addDocument(data: firestorePost,completion: { error in
                                self.imageView.image = UIImage(named: "tapToUploadImage")
                                self.commentTextField.text = ""
                                self.locationTextField.text = ""
                                self.navigationController?.popViewController(animated: true)
                            })

                        }
                    }
                }
            }
        }
    }
    func makeAlert(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    func uploadPostToFirestore(imageUrl: String, postedBy: String, isFavorite: Bool, location: String, comment: String) {
        getUserImageUrl { userImageUrl in
            let db = Firestore.firestore()
            
            // Firestore'a eklenecek verinin dictionary halini oluştur
            var postData: [String: Any] = [
                "date": Timestamp(date: Date()),
                "imageUrl": imageUrl,
                "postedBy": postedBy,
                "isFavorite": isFavorite,
                "location": location,
                "comment": comment
            ]
            
            // Kullanıcı görüntü URL'sini postData sözlüğüne ekle
            if let userImageUrl = userImageUrl {
                postData["userImageUrl"] = userImageUrl
            }
            
            // Firestore koleksiyonuna belirtilen veriyi ekle
            db.collection("posts").addDocument(data: postData) { error in
                if let error = error {
                    print("Veri yüklenirken hata oluştu: \(error.localizedDescription)")
                } else {
                    print("Veri başarıyla Firestore'a yüklendi.")
                }
            }
        }
    }
    func getUserImageUrl(completion: @escaping (String?) -> Void) {
        if let currentUser = Auth.auth().currentUser {
            let userId = currentUser.uid
            let userDocRef = Firestore.firestore().collection("users").document(userId)
        
            userDocRef.getDocument { document, error in
                if let document = document, document.exists {
                    if let userImageURLString = document["userImageURL"] as? String {
                        completion(userImageURLString)
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }

}
//MARK: - ImagePicker
extension AddPlaceVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
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
}
