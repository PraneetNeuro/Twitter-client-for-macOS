//
//  TrendModal.swift
//  Twitter
//
//  Created by Praneet S on 20/02/21.
//

import Foundation


struct TrendModal: Codable {
    let trends: [Trend]
    let asOf, createdAt: String
    let locations: [Location]

    enum CodingKeys: String, CodingKey {
        case trends
        case asOf = "as_of"
        case createdAt = "created_at"
        case locations
    }
}

// MARK: - Location
struct Location: Codable {
    let name: String
    let woeid: Int
}

// MARK: - Trend
struct Trend: Codable {
    let name: String
    let url: String
    let promotedContent: String?
    let query: String
    let tweetVolume: Int?

    enum CodingKeys: String, CodingKey {
        case name, url
        case promotedContent = "promoted_content"
        case query
        case tweetVolume = "tweet_volume"
    }
}

typealias trendModal = [TrendModal]

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
