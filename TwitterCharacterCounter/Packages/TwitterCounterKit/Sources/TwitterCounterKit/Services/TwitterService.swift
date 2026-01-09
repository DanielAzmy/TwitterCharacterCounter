//
//  TwitterService.swift
//  TwitterCharacterCounter
//
//  Created by Dodo's Mac on 07/01/2026.
//

import Foundation


@MainActor
public protocol TwitterServiceProtocol {
    func postTweet(_ text: String) async throws
}


public final class TwitterService: TwitterServiceProtocol {
    
    enum TwitterError: LocalizedError {
        case invalidCredentials
        case networkError
        case tweetTooLong
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .invalidCredentials:
                return "Invalid Twitter credentials. Please login again."
            case .networkError:
                return "Network error. Please check your connection."
            case .tweetTooLong:
                return "Tweet exceeds character limit."
            case .unknown:
                return "An unknown error occurred."
            }
        }
    }
    

    public func postTweet(_ text: String) async throws {
        try await Task.sleep(nanoseconds: 1_500_000_000)
        print("Tweet posted successfully: \(text)")
    }
}
