//
//  TweetComposerView.swift
//  TwitterCharacterCounter
//
//  Created by Dodo's Mac on 08/01/2026.
//

import SwiftUI

public struct TweetComposerView: View {
    @StateObject public var viewModel = TweetComposerViewModel()
    @FocusState public var isTextFieldFocused: Bool
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                headerView
                
                counterStatsView
                
                textEditorView
                
                Spacer()
                
                actionButtonsView
            }
            .navigationTitle("Twitter character count")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .alert("Success", isPresented: $viewModel.showSuccess) {
                Button("OK") {
                    viewModel.showSuccess = false
                }
            } message: {
                Text("Tweet posted successfully!")
            }
        }
    }
    
    // MARK: - Subviews
    
    public var headerView: some View {
        HStack {
            Spacer()
            Image("twitter")
                .resizable()
                .scaledToFit()
                .frame(height: 60)
                .font(.system(size: 40))
                .foregroundColor(.blue)
            Spacer()
        }
        .padding(.top, 20)
        .padding(.bottom, 10)
    }
    
    public var counterStatsView: some View {
        HStack(spacing: 20) {
            CounterCard(
                title: "Characters Typed",
                value: "\(viewModel.counter.characterCount)/\(viewModel.counter.limit)",
                color: viewModel.characterCountColor
            )
            
            CounterCard(
                title: "Characters Remaining",
                value: "\(viewModel.counter.remainingCharacters)",
                color: viewModel.characterCountColor
            )
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
    
    public var textEditorView: some View {
        ZStack(alignment: .topLeading) {
            if viewModel.tweetText.isEmpty {
                Text("Start typing! You can enter up to 280 characters")
                    .font(.system( size: 14))
                    .foregroundColor(.gray.opacity(0.6))
                    .padding(.top, 8)
                    .padding(.leading, 5)
            }
            
            TextEditor(text: $viewModel.tweetText)
                .focused($isTextFieldFocused)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isTextFieldFocused ? .teal : .gray)
                .fill(.white)
        )
        .padding(.horizontal)
        .onAppear {
            isTextFieldFocused = true
        }
    }
    
    public var actionButtonsView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button(action: viewModel.copyText) {
                    Text("Copy Text")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: 120)
                        .frame(height: 50)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                Spacer()
                
                Button(action: viewModel.clearText) {
                    Text("Clear Text")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: 120)
                        .frame(height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            
            Button(action: {
                Task {
                    await viewModel.postTweet()
                }
            }) {
                HStack {
                    if viewModel.isPosting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                    Text(viewModel.isPosting ? "Posting..." : "Post tweet")
                        .font(.system(size: 18, weight: .bold))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(viewModel.canPost ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(!viewModel.canPost)
        }
        .padding()
    }
}

// MARK: - Counter Card Component

public struct CounterCard: View {
    let title: String
    let value: String
    let color: Color
    
    public var body: some View {
        ZStack(alignment: .bottom){
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#E6F6FE"))
                .frame(maxWidth: 181)
                .frame(maxHeight: 120)
                .overlay(
                    Text(title)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.black)
                        .padding(.top, 10)
                        .multilineTextAlignment(.center),
                    alignment: .top
                )
            
            RoundedRectangle(cornerRadius: 0)
                .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
                .foregroundStyle(.white)
                .frame(maxWidth: 171)
                .frame(maxHeight: 80)
                .padding(.bottom, 2)
                .overlay(
                    Text(value)
                        .contentTransition(.symbolEffect)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center),
                    alignment: .center
                )
            
        }
    }
}

public struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255,
                           (int >> 8) * 17,
                           (int >> 4 & 0xF) * 17,
                           (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255,
                           int >> 16,
                           int >> 8 & 0xFF,
                           int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24,
                           int >> 16 & 0xFF,
                           int >> 8 & 0xFF,
                           int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(.sRGB,
                  red: Double(r) / 255,
                  green: Double(g) / 255,
                  blue: Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

// MARK: - Preview

#Preview {
    TweetComposerView()
}
