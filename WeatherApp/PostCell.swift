//
//  PostCell.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 20.02.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SDWebImage

class PostCell: UITableViewCell {

    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var IdLabel: UILabel!
    
    var post: Post?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func favoriteButtonClicked(_ sender: Any) {
     
        guard let post = post else { return }
        
        post.isFavorite.toggle()
        
        if post.isFavorite {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        updateFavoriteStatusInFirestore()
    }
    
    func configure(with post: Post) {
        
        self.post = post
        locationLabel.text = post.location
        usernameLabel.text = post.postedBy
        commentLabel.text = post.postComment
        dateLabel.text = post.postedTime
        
        if post.isFavorite {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        postImage.sd_setImage(with: URL(string: post.imageUrl))
    }
    func updateFavoriteStatusInFirestore() {
        guard (Auth.auth().currentUser?.email) != nil else {
            print("Current user email not found")
            return
        }
        let db = Firestore.firestore()
        
        if let Id = post?.documentId {
            db.collection("Posts").document(Id).updateData(["isFavorite": post!.isFavorite]) { error in
                if let error = error {
                    print("Error updating favorite status in Firestore: \(error.localizedDescription)")
                } else {
                    print("Favorite status updated successfully in Firestore")
                }
            }
        }
    }
}
