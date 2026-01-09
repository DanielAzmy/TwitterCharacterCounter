//
//  TweetComposerViewModel.swift
//  TwitterCharacterCounter
//
//  Created by Dodo's Mac on 07/01/2026.
//

import Foundation

import SwiftUI
import Combine

@MainActor
public final class TweetComposerViewModel: ObservableObject {
    
    @Published var tweetText: String = ""
    @Published var counter: TwitterCounter
    @Published var isPosting: Bool = false
    @Published var errorMessage: String?
    @Published var showSuccess: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var successMessage: String?
    
    private let twitterService: TwitterServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private let characterLimit = TwitterCharacterCounter.twitterLimit
    
    var canPost: Bool {
        !tweetText.isEmpty && counter.isValid && !isPosting
    }
    
    var characterCountColor: Color {
        let remaining = counter.remainingCharacters
        if remaining < 0 {
            return .red
        } else if remaining < 20 {
            return .orange
        } else {
            return .primary
        }
    }
    
    init(twitterService: TwitterServiceProtocol? = nil) {
        self.twitterService =  TwitterServiceFactory.create(useMock: true)
        self.counter = TwitterCounter(text: "")
        self.isAuthenticated = self.twitterService.isAuthenticated()
        setupBindings()
    }
    
    private func setupBindings() {
        $tweetText
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.updateCounter(with: text)
            }
            .store(in: &cancellables)
    }
    
    func updateCounter(with text: String) {
        counter = TwitterCounter(text: text, limit: characterLimit)
    }
    
    func login() async {
        // for mock service
        if let mockService = twitterService as? MockTwitterService {
            do {
                try await mockService.authenticate(username: "demo", password: "demo")
                isAuthenticated = true
            } catch {
                errorMessage = "Login failed: \(error.localizedDescription)"
            }
        }
    }
    
    func logout() {
        if let mockService = twitterService as? MockTwitterService {
            mockService.logout()
            isAuthenticated = false
        }
    }
    
    func postTweet() async {
        guard canPost else {
            if !isAuthenticated {
                errorMessage = "Please login first"
            }
            return
        }
        
        isPosting = true
        errorMessage = nil
        successMessage = nil
        
        do {
            let response = try await twitterService.postTweet(tweetText)
            successMessage = "Tweet posted successfully!\nTweet ID: \(response.data.id)"
            showSuccess = true
            clearText()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isPosting = false
    }
    
    func clearText() {
        tweetText = ""
        updateCounter(with: "")
    }
    
    func copyText() {
        UIPasteboard.general.string = tweetText
    }
}

extension TweetComposerViewModel {
    var Color: SwiftUI.Color.Type { SwiftUI.Color.self }
}
