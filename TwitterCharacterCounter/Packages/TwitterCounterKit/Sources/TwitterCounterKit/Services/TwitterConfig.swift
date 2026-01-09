//
//  TwitterConfig.swift
//  TwitterCharacterCounter
//
//  Created by Dodo's Mac on 09/01/2026.
//

import Foundation

public struct TwitterConfig {
    // In production, these would come from Twitter Developer Portal
    static let apiVersion = "2"
    static let baseURL = "https://api.twitter.com"
    static let tweetEndpoint = "/2/tweets"
    
    static let authURL = "https://twitter.com/i/oauth2/authorize"
    static let tokenURL = "https://api.twitter.com/2/oauth2/token"
    
    // Mock credentials (would be real in production)
    static let mockAccessToken = "mock_access_token_12345"
    static let mockClientId = "demo_client_id"
}
