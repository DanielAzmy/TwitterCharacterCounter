//
//  String+TwitterCount.swift
//  TwitterCounterKit
//
//  Created by Dodo's Mac on 07/01/2026.
//

import Foundation

public extension String {
    func twitterCharacterCount() -> Int {
        let counter = TwitterCharacterCounter()
        return counter.count(self)
    }
    
    func twitterReimainingCharacterCount(limit: Int = TwitterCharacterCounter.twitterLimit) -> Int {
        let counter = TwitterCharacterCounter()
        return counter.remainingCharacters(self, limit: limit)
    }
}
