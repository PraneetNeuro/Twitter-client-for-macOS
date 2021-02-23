//
//  timelineModal.swift
//  Twitter
//
//  Created by Praneet S on 18/02/21.
//
// 

import Foundation

struct Timeline: Codable {
    let data: [Datum]?
    let includes: Includes?
    let meta: Meta?
}

// MARK: - Datum
struct Datum: Codable {
    let text, createdAt: String?
    let contextAnnotations: [ContextAnnotation]?
    let attachments: Attachments?
    let entities: DatumEntities?
    let public_metrics: DatumPublicMetrics?
    let replySettings, authorid, lang, id: String?
    let conversationid: String?
    let possiblySensitive: Bool?
    let source: String?
    let referencedTweets: [ReferencedTweet]?
    let inReplyToUserid: String?
    
    enum CodingKeys: String, CodingKey {
        case text
        case createdAt
        case contextAnnotations
        case attachments, entities
        case public_metrics = "public_metrics"
        case replySettings
        case authorid = "author_id"
        case lang, id
        case conversationid
        case possiblySensitive
        case source
        case referencedTweets
        case inReplyToUserid
    }
}

// MARK: - Attachments
struct Attachments: Codable {
    let mediaKeys: [String]?
    
    enum CodingKeys: String, CodingKey {
        case mediaKeys = "media_keys"
    }
}

// MARK: - ContextAnnotation
struct ContextAnnotation: Codable {
    let domain, entity: Domain?
}

// MARK: - Domain
struct Domain: Codable {
    let id, name, domainDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case domainDescription
    }
}

// MARK: - DatumEntities
struct DatumEntities: Codable {
    let annotations: [Annotation]?
    let hashtags: [Hashtag]?
    let urls: [URLurl]?
    let mentions: [Mention]?
}

// MARK: - Annotation
struct Annotation: Codable {
    let start, end: Int?
    let probability: Double?
    let type, normalizedText: String?
    
    enum CodingKeys: String, CodingKey {
        case start, end, probability, type
        case normalizedText
    }
}

// MARK: - Hashtag
struct Hashtag: Codable {
    let start, end: Int?
    let tag: String?
}

// MARK: - Mention
struct Mention: Codable {
    let start, end: Int?
    let username: String?
}

// MARK: - URLurl
struct URLurl: Codable {
    let start, end: Int?
    let url: String?
    let expandedurl: String?
    let displayurl: String?
    
    enum CodingKeys: String, CodingKey {
        case start, end, url
        case expandedurl
        case displayurl
    }
}

// MARK: - DatumPublicMetrics
struct DatumPublicMetrics: Codable {
    let retweetCount, replyCount, likeCount, quoteCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case retweetCount = "retweet_count"
        case replyCount = "reply_count"
        case likeCount = "like_count"
        case quoteCount = "quote_count"
    }
}

// MARK: - ReferencedTweet
struct ReferencedTweet: Codable {
    let type, id: String?
}

// MARK: - Includes
struct Includes: Codable {
    let media: [Media]?
    let users: [User]?
    let tweets: [Tweet]?
}

// MARK: - Media
struct Media: Codable {
    let mediaKey, url, type: String?
    
    enum CodingKeys: String, CodingKey {
        case mediaKey = "media_key"
        case type
        case url
    }
}

// MARK: - Tweet
struct Tweet: Codable {
    let text, createdAt: String?
    let contextAnnotations: [ContextAnnotation]?
    let entities: TweetEntities?
    let publicMetrics: DatumPublicMetrics?
    let replySettings, authorid, lang, id: String?
    let conversationid: String?
    let possiblySensitive: Bool?
    let source: String?
    
    enum CodingKeys: String, CodingKey {
        case text
        case createdAt
        case contextAnnotations
        case entities
        case publicMetrics
        case replySettings
        case authorid
        case lang, id
        case conversationid
        case possiblySensitive
        case source
    }
}

// MARK: - TweetEntities
struct TweetEntities: Codable {
    let annotations: [Annotation]?
    let hashtags: [Hashtag]?
    let urls: [Purpleurl]?
    let mentions: [Mention]?
}

// MARK: - Purpleurl
struct Purpleurl: Codable {
    let start, end: Int?
    let url: String?
    let expandedurl: String?
    let displayurl: String?
    let images: [Image]?
    let status: Int?
    let title, urlDescription: String?
    let unwoundurl: String?
    
    enum CodingKeys: String, CodingKey {
        case start, end, url
        case expandedurl
        case displayurl
        case images, status, title
        case urlDescription
        case unwoundurl
    }
}

// MARK: - Image
struct Image: Codable {
    let url: String?
    let width, height: Int?
}

// MARK: - User
struct User: Codable {
    let profileImageurl: String?
    let name, id: String?
    let url: String?
    let pinnedTweetid: String?
    let publicMetrics: UserPublicMetrics?
    let username, location, createdAt: String?
    let protected: Bool?
    let entities: UserEntities?
    let verified: Bool?
    let userDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case profileImageurl = "profile_image_url"
        case name, id, url
        case pinnedTweetid
        case publicMetrics
        case username, location
        case createdAt
        case protected, entities, verified
        case userDescription
    }
}

// MARK: - UserEntities
struct UserEntities: Codable {
    let url: Fluffyurl?
    let entitiesDescription: Description?
    
    enum CodingKeys: String, CodingKey {
        case url
        case entitiesDescription
    }
}

// MARK: - Description
struct Description: Codable {
    let hashtags: [Hashtag]?
    let mentions: [Mention]?
}

// MARK: - Fluffyurl
struct Fluffyurl: Codable {
    let urls: [URLurl]?
}

// MARK: - UserPublicMetrics
struct UserPublicMetrics: Codable {
    let followersCount, followingCount, tweetCount, listedCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case followersCount
        case followingCount
        case tweetCount
        case listedCount
    }
}

// MARK: - Meta
struct Meta: Codable {
    let oldestid, newestid: String?
    let resultCount: Int?
    let nextToken: String?
    
    enum CodingKeys: String, CodingKey {
        case oldestid
        case newestid
        case resultCount
        case nextToken
    }
}
