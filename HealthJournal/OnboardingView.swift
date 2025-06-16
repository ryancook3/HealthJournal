//
//  OnboardingView.swift
//  HealthJournal
//
//  Created by Ryan Cook on 6/1/25.
//
import SwiftUI

struct OnboardingView: View {
    @Binding var hasCompletedOnboarding: Bool
    @AppStorage("useHealthKit") private var useHealthKit = false
    @State private var selection: HealthMode = .manual

    enum HealthMode { case manual, healthkit }

    var body: some View {
        ZStack {
            // Soft gradient background
            LinearGradient(gradient: Gradient(colors: [Color.accentColor.opacity(0.15), Color.purple.opacity(0.10)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            // Decorative shape
            Circle()
                .fill(Color.accentColor.opacity(0.12))
                .frame(width: 320, height: 320)
                .offset(x: -120, y: -220)
            VStack(spacing: 32) {
                Spacer()
                // Animated App Icon
                Image(systemName: "heart.text.square.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.accentColor)
                    .shadow(radius: 8)
                // Title & Subtitle
                VStack(spacing: 8) {
                    Text("Welcome to Health Journal")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    Text("Your private space for wellness, reflection, and growth.")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                // Tagline
                Text("Track your thoughts, habits, and health insights with ease. Connect with Apple Health for automatic stats.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                // Health Data Mode Selection
                VStack(spacing: 16) {
                    Text("How would you like to add your health stats?")
                        .font(.headline)
                        .padding(.bottom, 4)
                    HStack(spacing: 16) {
                        HealthModeCard(
                            icon: "apple.logo",
                            title: "Connect to Apple Health",
                            description: "Auto-import steps, sleep, heart rate, and more.",
                            selected: selection == .healthkit,
                            action: { selection = .healthkit }
                        )
                        HealthModeCard(
                            icon: "pencil.and.outline",
                            title: "Add Stats Manually",
                            description: "Enter your stats yourself. You can connect Health later.",
                            selected: selection == .manual,
                            action: { selection = .manual }
                        )
                    }
                }
                Spacer()
                // Get Started Button
                Button(action: {
                    useHealthKit = (selection == .healthkit)
                    hasCompletedOnboarding = true
                }) {
                    HStack {
                        Spacer()
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(14)
                    .shadow(radius: 4)
                }
                .padding(.horizontal)
                Spacer(minLength: 40)
            }
            .padding()
        }
    }
}

struct HealthModeCard: View {
    let icon: String
    let title: String
    let description: String
    let selected: Bool
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(selected ? .white : .accentColor)
                    .padding(12)
                    .background(selected ? Color.accentColor : Color(.systemGray6).opacity(0.7))
                    .clipShape(Circle())
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(selected ? .accentColor : .primary)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(12)
            .frame(width: 150)
            .background(selected ? Color.accentColor.opacity(0.12) : Color(.systemGray6).opacity(0.7))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(selected ? Color.accentColor : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(false))
}
