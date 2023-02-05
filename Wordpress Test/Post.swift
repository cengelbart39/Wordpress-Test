//
//  Post.swift
//  Wordpress Test
//
//  Created by Christopher Engelbart on 1/31/23.
//

import Foundation

/// A struct containing information from a processed ``RawPost``
struct Post: Identifiable {
    
    /// The id of the ``Post``
    var id: Int
    
    /// The date it was created
    var date: Date
    
    /// The URL of the post
    var link: String
    
    /// The title of the post
    var title: AttributedString
    
    /// The content of the post
    var content: [AttributedString]
    
    /// An excerpt of the post
    var excerpt: AttributedString
    
    /// The author id
    var author: Int
    
    /// The associated category ids for the post
    var categories: [Int]
}

extension Post {
    /// Default Constructor
    init() {
        self.id = -1
        self.date = Date()
        self.link = ""
        self.title = AttributedString()
        self.content = []
        self.excerpt = AttributedString()
        self.author = -1
        self.categories = []
    }
}
