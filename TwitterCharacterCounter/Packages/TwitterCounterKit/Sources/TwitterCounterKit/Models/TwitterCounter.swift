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
