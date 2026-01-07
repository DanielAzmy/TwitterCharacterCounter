//
//  TwitterCharacterCounter.swift
//  TwitterCharacterCounter
//
//  Created by Dodo's Mac on 07/01/2026.
//

import Foundation

public final class TwitterCharacterCounter: CharacterCounterProtocol{
    
    public init() {}
    
    public func count(_ text: String) -> Int {
        var count  = 0
        let text = text as NSString
        
        let urlPattern = "https?://[^\\s]+"
        let urlRegex = try? NSRegularExpression(pattern: urlPattern)
        let urlMatches = urlRegex?.matches(in: text as String, range: NSRange(location: 0, length: text.length)) ?? []
        
        var processedRanges: [NSRange] = []
        for match in urlMatches {
            count += 23
            processedRanges.append(match.range)
        }
        
        text.enumerateSubstrings(in: NSRange(location: 0, length: text.length),
                                 options: .byComposedCharacterSequences) { substring, range, _, _ in
            let isInURL = processedRanges.contains { urlRange in
                NSIntersectionRange(range, urlRange).length > 0
            }
            
            guard !isInURL else { return }
            
            if let substring = substring {
                let scalars = substring.unicodeScalars
                let isEmoji = scalars.contains { scalar in
                    scalar.properties.isEmoji ||
                    scalar.value > 0x10000
                }
                
                count += isEmoji ? 2 : 1
            }
        }
        return count
    }

    public func remainingCharacters(_ text: String, limit: Int) -> Int {
        return limit - count(text)
    }

    public func isValid(_ text: String, limit: Int) -> Bool {
        return count(text) <= limit
    }
 
}

extension TwitterCharacterCounter {
    public static let twitterLimit = 280
}
