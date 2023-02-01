//
//  RawPost.swift
//  Wordpress Test
//
//  Created by Christopher Engelbart on 1/31/23.
//

import Foundation

struct RawPost: Decodable, Identifiable {
    var id: Int
    var date: String
    var dateGMT: String
    var guid: RawPostGUID
    var modified: String
    var modifiedGMT: String
    var slug: String
    var status: String
    var type: String
    var link: String
    var title: RawPostTitle
    var content: RawPostContent
    var excerpt: RawPostExcerpt
    var author: Int
    var featuredMedia: Int
    var commentStatus: String
    var pingStatus: String
    var sticky: Bool
    var template: String
    var format: String
    var meta: [String:Bool]
    var categories: [Int]
    var tags: [String]
    var _links: RawPostLinks
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case dateGMT = "date_gmt"
        case guid
        case modified
        case modifiedGMT = "modified_gmt"
        case slug
        case status
        case type
        case link
        case title
        case content
        case excerpt
        case author
        case featuredMedia = "featured_media"
        case commentStatus = "comment_status"
        case pingStatus = "ping_status"
        case sticky
        case template
        case format
        case meta
        case categories
        case tags
        case _links
    }
    
}

struct RawPostGUID: Decodable {
    var rendered: String
}

struct RawPostTitle: Decodable {
    var rendered: String
}

struct RawPostContent: Decodable {
    var rendered: String
    var protected: Bool
}

struct RawPostExcerpt: Decodable {
    var rendered: String
    var protected: Bool
}

struct RawPostLinks: Decodable {
    var apiLink: [RawPostLinksHref]
    var collection: [RawPostLinksHref]
    var about: [RawPostLinksHref]
    var author: [RawPostLinksEmbeddable]
    var replies: [RawPostLinksEmbeddable]
    var versionHistory: [RawPostLinksCount]
    var predecessorVersion: [RawPostLinksId]
    var wpAttachment: [RawPostLinksHref]
    var wpTerm: [RawPostLinksTaxonomy]
    var curies: [RawPostLinksName]
    
    enum CodingKeys: String, CodingKey {
        case apiLink = "self"
        case collection
        case about
        case author
        case replies
        case versionHistory = "version-history"
        case predecessorVersion = "predecessor-version"
        case wpAttachment = "wp:attachment"
        case wpTerm = "wp:term"
        case curies
    }
}


struct RawPostLinksHref: Decodable {
    var href: String
}

struct RawPostLinksEmbeddable: Decodable {
    var embeddable: Bool
    var href: String
}

struct RawPostLinksCount: Decodable {
    var count: Int
    var href: String
}

struct RawPostLinksId: Decodable {
    var id: Int
    var href: String
}

struct RawPostLinksTaxonomy: Decodable {
    var taxonomy: String
    var embeddable: Bool
    var href: String
}

struct RawPostLinksName: Decodable {
    var name: String
    var href: String
    var templated: Bool
}
