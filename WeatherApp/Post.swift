//
//  Post.swift
//  WeatherApp
//
//  Created by İbrahim Utku Adanur on 20.02.2024.
//

import Foundation

class Post {
    var imageUrl: String = ""
    var isFavorite: Bool
    var postComment: String = ""
    var postedBy: String = ""
    var location: String = ""
    var postedTime: String = ""
    var documentId: String = ""
    
    init(imageUrl: String, isFavorite: Bool, postComment: String, postedBy: String, location: String, postedTime: String, documentId: String) {
            self.imageUrl = imageUrl
            self.isFavorite = isFavorite
            self.postComment = postComment
            self.postedBy = postedBy
            self.location = location
            self.postedTime = postedTime
            self.documentId = documentId
    }
}
