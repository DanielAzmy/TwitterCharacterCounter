//
//  RealTwitterService.swift
//  TwitterCounterKit
//
//  Created by Dodo's Mac on 09/01/2026.
//

import Foundation

public final class RealTwitterService: TwitterServiceProtocol {
    
    private var accessToken: String?
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func isAuthenticated() -> Bool {
        return accessToken != nil
    }
    
    public func postTweet(_ text: String) async throws -> TweetResponse {
        guard let accessToken = accessToken else {
            throw TwitterServiceError.notAuthenticated
        }
        
        let urlString = "\(TwitterConfig.baseURL)\(TwitterConfig.tweetEndpoint)"
        guard let url = URL(string: urlString) else {
            throw TwitterServiceError.unknown
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let tweetRequest = TweetRequest(text: text)
        request.httpBody = try JSONEncoder().encode(tweetRequest)
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TwitterServiceError.networkError
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            let tweetResponse = try JSONDecoder().decode(TweetResponse.self, from: data)
            return tweetResponse
            
        case 401:
            throw TwitterServiceError.invalidCredentials
            
        case 429:
            throw TwitterServiceError.rateLimitExceeded
            
        case 400...499:
            if let errorResponse = try? JSONDecoder().decode(TwitterErrorResponse.self, from: data) {
                throw TwitterServiceError.serverError(errorResponse.detail ?? "Client error")
            }
            throw TwitterServiceError.unknown
            
        case 500...599:
            throw TwitterServiceError.serverError("Twitter server error")
            
        default:
            throw TwitterServiceError.unknown
        }
    }
    
    func authenticate(using authCode: String, codeVerifier: String) async throws {
        // Implementation for token exchange
        // Store token in Keychain
    }
}

// MARK: - Twitter Service Factory
enum TwitterServiceFactory {
    @MainActor
    static func create(useMock: Bool = true) -> TwitterServiceProtocol {
        if useMock {
            return MockTwitterService()
        } else {
            return RealTwitterService()
        }
    }
}
