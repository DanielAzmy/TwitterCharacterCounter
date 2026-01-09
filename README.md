# Twitter Character Counter

A modern iOS app that counts Twitter characters following Twitter's official rules, with a clean MVVM architecture.

## 📱 Features

- Real-time character counting
- Twitter-compliant counting (URLs = 23 chars, Emojis = 2 chars)
- Mock Twitter integration (simulates posting tweets)
- Clean MVVM architecture
- Swift Package for reusability
- Unit tests

## 🔧 About Twitter Integration

### Why Mock Service?

This app uses a **mock Twitter service** instead of real Twitter API integration because:

1. **Twitter Developer Account Requirements**: To use the real Twitter API, you need:
   - A verified Twitter/X account (phone number + email)
   - Approved Twitter Developer account (takes 24+ hours)
   - API credentials (Client ID & Secret)

2. **Interview/Demo Purpose**: The mock service is perfect for:
   - Demonstrating architecture understanding
   - Testing the app without API keys
   - Showing error handling and async operations

### What the Mock Service Does

The `MockTwitterService` simulates real Twitter API behavior:

✅ **Realistic Features:**
- Login/logout functionality
- 1.5 second network delay (like real API)
- Success responses with tweet IDs
- Error handling (10% random errors for demo)
- Authentication state management

✅ **Matches Real API Structure:**
- Same method signatures
- Same response models
- Same error types
- Ready to swap with real implementation

### How It Works

```swift
// Login (simulated)
await viewModel.login()

// Post tweet (simulated with delay)
await viewModel.postTweet()

// Get response like real API
// "Tweet posted successfully! Tweet ID: mock_tweet_1_abc123"
```

### Switching to Real Twitter API

When you get Twitter API access, just:

1. Get verified Twitter account
2. Apply for Developer account
3. Get API credentials
4. Update `TwitterConfig.swift` with credentials
5. Change one line: `TwitterServiceFactory.create(useMock: false)`

That's it! The code is already structured for real API integration.

## 🏗️ Architecture

**MVVM Pattern:**
- **Models**: `TwitterCounter`, `TwitterCharacterCounter`
- **Views**: `TweetComposerView`
- **ViewModels**: `TweetComposerViewModel`
- **Services**: `MockTwitterService` (protocol-based)

**Swift Package:**
- Character counting logic extracted to `TwitterCounterKit`
- Reusable across projects
- Easy to test

## 🚀 Getting Started

1. Clone the repo
2. Open `TwitterCharacterCounter.xcodeproj`
3. Build and run (Cmd + R)
4. Type a tweet and click "Post tweet"


## 📝 Twitter Character Rules

- Regular text: 1 character each
- Emojis: 2 characters each
- URLs: 23 characters (Twitter shortens to t.co)
- Maximum: 280 characters total

## 🎯 Key Implementation Details

### Character Counting Algorithm
```swift
// URLs detected and counted as 23 chars
"Check https://example.com" = 6 + 23 = 29 chars

// Emojis counted as 2 chars
"Hello 😀" = 5 + 2 = 7 chars
```

### Mock Service Benefits
- **No API keys needed** - Works out of the box
- **Predictable testing** - No network dependencies
- **Fast development** - No rate limits or quotas
- **Demo-ready** - Shows all features working



## 💡 Note for Reviewers

This project demonstrates:
- Clean architecture principles
- Protocol-oriented design
- Async/await patterns
- Error handling
- UI/UX best practices

The mock service shows understanding of API integration without requiring actual Twitter credentials. The code is structured so switching to real API is trivial when credentials are available.

## 📄 License

This project is for educational/interview purposes.

---

**Built with SwiftUI, MVVM, and ❤️**
