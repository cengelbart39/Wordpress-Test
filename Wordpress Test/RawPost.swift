//
//  RawPost.swift
//  Wordpress Test
//
//  Created by Christopher Engelbart on 1/31/23.
//

import Foundation

/// The raw Post output from ``WordpressService``
struct RawPost: Decodable, Identifiable {
    
    /// Unique identifier for the object
    var id: Int
    
    /// The date the object was published, in the site's timezone
    var date: String
    
    /// The date the object was published, as GMT
    var dateGMT: String
    
    /// The globally unique identifier for the object
    var guid: RawPostRendered
    
    /// The date the object was last modified, in the site's timezone
    var modified: String
    
    /// The date the object was last modified, as GMT
    var modifiedGMT: String
    
    /// Portion of ``link`` following date
    var slug: String
    
    /**
     A named status for the object
     - publish
     - feature
     - draft
     - pending
     - private
     */
    var status: String
    
    /// Type of Post for the object
    var type: String
    
    /// URL to the object
    var link: String
    
    /// The title for the object
    var title: RawPostRendered
    
    /// The content for the object
    var content: RawPostProtected
    
    /// The excerpt for the object
    var excerpt: RawPostProtected
    
    /// The ID for the author of the object
    var author: Int
    
    /// The ID of the featured media for the object
    var featuredMedia: Int
    
    /// Whether or not comments are open on the object
    /// - open
    /// - closed
    var commentStatus: String
    
    /// Whether or not the object can be pinged
    var pingStatus: String
    
    /// Whether or not the object should be treated as sticky
    var sticky: Bool
    
    /// The theme file to use to display the object
    var template: String
    
    /// The format for the object
    /// - standard
    /// - aside
    /// - chat
    /// - gallery
    /// - link
    /// - image
    /// - quote
    /// - status
    /// - video
    /// - audio
    var format: String
    
    /// Meta fields
    var meta: [String:Bool]
    
    /// The terms assigned to the object in the category taxonomy
    var categories: [Int]
    
    /// The terms assigned to the object in the post_tag taxonomy
    var tags: [String]
    
    /// Various related API call links to the ``Post``
    var _links: RawPostLinks
    
    /// Coding Keys for ``RawPost``
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

/// A struct that represents ``RawPost`` properties with a `rendered` field
struct RawPostRendered: Decodable {
    
    /// Depending on the context, could be HTML or a URL
    var rendered: String
}

/// Similar to ``RawPostRendered``, but with a `protected` field
struct RawPostProtected: Decodable {
    
    /// Depending on the context, could be HTML or a URL
    var rendered: String
    
    /// Whether the ``rendered`` content is password-protected
    var protected: Bool
}

/// Various related API call links to the ``RawPost``
struct RawPostLinks: Decodable {
    
    /// A link to get data about this specific ``RawPost``
    var apiLink: [RawPostLinksHref]
    
    /// A link to get data about ``RawPost``s
    var collection: [RawPostLinksHref]
    
    /// A link to information about ``RawPost``
    var about: [RawPostLinksHref]
    
    /// A link to the specific author of this ``RawPost``
    var author: [RawPostLinksEmbeddable]
    
    /// A link to all the replies of this ``RawPost``
    var replies: [RawPostLinksEmbeddable]
    
    /// A link to the version history of this ``RawPost``
    var versionHistory: [RawPostLinksCount]
    
    /// A link to the version history of the predecessor of this ``RawPost``
    var predecessorVersion: [RawPostLinksId]
    
    /// A link to related attachments of this ``RawPost``
    var wpAttachment: [RawPostLinksHref]
    
    /// A link to related taxonomies of this ``RawPost``
    var wpTerm: [RawPostLinksTaxonomy]
    
    /// A link to get the related Compact URIs for this ``RawPost``
    var curies: [RawPostLinksName]
    
    /// The appropriate `CodingKeys` for ``RawPostLinks``
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


/// A struct containing only a `href` URL
struct RawPostLinksHref: Decodable {
    
    /// An API Call URL
    var href: String
}

/// A struct containing a `href` URL and whether its embeddable
struct RawPostLinksEmbeddable: Decodable {
    
    /// Whether ``href`` can be embedded
    var embeddable: Bool
    
    /// An API Call URL
    var href: String
}

/// A struct containing a `href` URL and a count of revisions
struct RawPostLinksCount: Decodable {
    
    /// The number of revisions
    var count: Int
    
    /// An API Call URL
    var href: String
}

/// A struct containing a `href` URL and an id
struct RawPostLinksId: Decodable {
    
    /// The ID of a related object
    var id: Int
    
    /// An API Call URL
    var href: String
}

/// A struct containing a `href` URL , whether its embeddable, and its taxonomy
struct RawPostLinksTaxonomy: Decodable {
    
    /// Classification of ``href``
    var taxonomy: String
    
    /// Whether ``href`` can be embedded
    var embeddable: Bool
    
    /// An API Call URL
    var href: String
}

/// A struct containing a `href` URL ,  its name, and whether its templated

struct RawPostLinksName: Decodable {
    
    /// A related name to ``href``
    var name: String
    
    /// A URL
    var href: String
    
    /// Whether it is templated
    var templated: Bool
}
