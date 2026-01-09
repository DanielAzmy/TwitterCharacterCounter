//
//  TwitterService.swift
//  TwitterCharacterCounter
//
//  Created by Dodo's Mac on 07/01/2026.
//

import Foundation

@MainActor
public protocol TwitterServiceProtocol {
    func postTweet(_ text: String) async throws -> TweetResponse
    func isAuthenticated() -> Bool
}

// MARK: - Twitter Service Error
enum TwitterServiceError: LocalizedError {
    case notAuthenticated
    case invalidCredentials
    case networkError
    case tweetTooLong
    case rateLimitExceeded
    case serverError(String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "Please login to Twitter first."
        case .invalidCredentials:
            return "Invalid Twitter credentials. Please login again."
        case .networkError:
            return "Network error. Please check your connection."
        case .tweetTooLong:
            return "Tweet exceeds character limit (280 characters)."
        case .rateLimitExceeded:
            return "Rate limit exceeded. Please try again later."
        case .serverError(let message):
            return "Server error: \(message)"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

// MARK: - Mock Twitter Service (For Demo/Interview)
public final class MockTwitterService: TwitterServiceProtocol {
    
    private var isLoggedIn = false
    private var mockTweetCounter = 1
    
    func authenticate(username: String, password: String) async throws {
        try await Task.sleep(nanoseconds: 1_000_000_000)

        isLoggedIn = true
        print("Mock: User authenticated successfully")
    }
    
    func logout() {
        isLoggedIn = false
        print("Mock: User logged out")
    }
    
    public func isAuthenticated() -> Bool {
        return isLoggedIn
    }
    
    public func postTweet(_ text: String) async throws -> TweetResponse {
        // Validate authentication
        guard isLoggedIn else {
            throw TwitterServiceError.notAuthenticated
        }
        
        let counter = TwitterCharacterCounter()
        let count = counter.count(text)
        guard count <= 280 else {
            throw TwitterServiceError.tweetTooLong
        }
        
        // simulate network delay
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        
        
        let tweetId = "mock_tweet_\(mockTweetCounter)_\(UUID().uuidString.prefix(8))"
        mockTweetCounter += 1
        
        let response = TweetResponse(
            data: TweetData(
                id: tweetId,
                text: text
            )
        )
        
        print(" Mock: Tweet posted successfully")
        print("   ID: \(tweetId)")
        print("   Text: \(text)")
        print("   Length: \(count) characters")
        
        return response
    }
}
