//
//  PostsVC.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 20.02.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class PostsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedLocation: String?
    private var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.tintColor = .black
        title = selectedLocation ?? "Posts"
        
        if let location = selectedLocation {
            getPosts(for: location)
        }
        tableView.dataSource = self
        tableView.delegate = self
    }
    private func getPosts(for location: String) {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
                print("Current user email not found")
                return
        }
        let db = Firestore.firestore()
        
        db.collection("Posts")
                .whereField("location", isEqualTo: location)
                .whereField("postedBy", isEqualTo: currentUserEmail)
                .getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        guard let snapshot = snapshot else { return }
                
                        self.posts = snapshot.documents.compactMap { document in
                            let data = document.data()
                            let imageUrl = data["imageUrl"] as? String ?? ""
                            let isFavorite = data["isFavorite"] as? Bool ?? false
                            let postComment = data["postComment"] as? String ?? ""
                            let postedBy = data["postedBy"] as? String ?? ""
                            let timestamp = data["date"] as? Timestamp
                            //Converting Timestamp into Date
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd-MM-yyyy"
                            let formattedDate = dateFormatter.string(from: timestamp?.dateValue() ?? Date())
                            let documentId = document.documentID
                            
                            return Post(imageUrl: imageUrl, isFavorite: isFavorite, postComment: postComment, postedBy: postedBy, location: location, postedTime: formattedDate, documentId: documentId)
                        
                    }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension PostsVC: UITableViewDataSource, UITableViewDelegate {
    
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
