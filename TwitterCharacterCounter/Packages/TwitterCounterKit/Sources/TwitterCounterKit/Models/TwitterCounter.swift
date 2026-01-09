//
//  TwitterCounter.swift
//  TwitterCharacterCounter
//
//  Created by Dodo's Mac on 07/01/2026.
//

import Foundation


public struct TwitterCounter {
    public let text: String
    public let characterCount: Int
    public let remainingCharacters: Int
    public let isValid: Bool
    public let limit: Int
    
    public init(text: String, limit: Int = TwitterCharacterCounter.twitterLimit) {
        let counter = TwitterCharacterCounter()
        self.text = text
        self.limit = limit
        self.characterCount = counter.count(text)
        self.remainingCharacters = counter.remainingCharacters(text, limit: limit)
        self.isValid = counter.isValid(text, limit: limit)
    }
}

public struct TweetRequest: Codable {
    let text: String
}

public struct TweetResponse: Codable {
    let data: TweetData
}

public struct TweetData: Codable {
    let id: String
    let text: String
}

public struct TwitterUser: Codable {
    let id: String
    let name: String
    let username: String
}

public struct TwitterErrorResponse: Codable {
    let title: String?
    let detail: String?
    let type: String?
    let status: Int?
}
