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
    
    // MARK: - Published Properties
    @Published var tweetText: String = ""
    @Published var counter: TwitterCounter
    @Published var isPosting: Bool = false
    @Published var errorMessage: String?
    @Published var showSuccess: Bool = false
    
    // MARK: - Dependencies
    public let twitterService: TwitterServiceProtocol
    public var cancellables = Set<AnyCancellable>()
    
    // MARK: - Constants
    public let characterLimit = TwitterCharacterCounter.twitterLimit
    
    // MARK: - Computed Properties
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
    
    // MARK: - Initialization
    init(twitterService: TwitterServiceProtocol = TwitterService()) {
        self.twitterService = twitterService
        self.counter = TwitterCounter(text: "")
        setupBindings()
    }
    
    // MARK: - Setup
    public func setupBindings() {
        $tweetText
            .debounce(for: .milliseconds(100), scheduler: DispatchQueue.main)
            .sink { [weak self] text in
                self?.updateCounter(with: text)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    func updateCounter(with text: String) {
        counter = TwitterCounter(text: text, limit: characterLimit)
    }
    
    func postTweet() async {
        guard canPost else { return }
        
        isPosting = true
        errorMessage = nil
        
        do {
            try await twitterService.postTweet(tweetText)
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
