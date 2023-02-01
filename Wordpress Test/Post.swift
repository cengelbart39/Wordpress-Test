//
//  Post.swift
//  Wordpress Test
//
//  Created by Christopher Engelbart on 1/31/23.
//

import Foundation

struct Post: Identifiable {
    var id: Int
    var date: Date
    var link: String
    var title: AttributedString
    var content: [AttributedString]
    var excerpt: AttributedString
    var author: Int
    var categories: [Int]
}

extension Post {
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
