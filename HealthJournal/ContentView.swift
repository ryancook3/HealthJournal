//
//  ContentView.swift
//  HealthJournal
//
//  Created by Ryan Cook on 5/19/25.
//
import SwiftUI

struct ContentView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("isAuthenticated") private var isAuthenticated = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            // Shared gradient background and decorative shape
            LinearGradient(gradient: Gradient(colors: [Color.accentColor.opacity(0.15), Color.purple.opacity(0.10)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            Circle()
                .fill(Color.accentColor.opacity(0.12))
                .frame(width: 260, height: 260)
                .offset(x: 120, y: -180)
            if !hasCompletedOnboarding {
                OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
            } else if !isAuthenticated {
                AuthView(isAuthenticated: $isAuthenticated)
            } else {
                TabView {
                    MainJournalView()
                        .tabItem {
                            Label("Journal", systemImage: "book.fill")
                        }
                    RecapStatsView()
                        .tabItem {
                            Label("Insights", systemImage: "lightbulb")
                        }
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape.fill")
                        }
                }
                .tint(colorScheme == .dark ? .white : .blue)
                .preferredColorScheme(colorScheme)
            }
        }
        .onAppear {
            print("DEBUG: hasCompletedOnboarding = \(hasCompletedOnboarding)")
            // Temporarily force onboarding to show for debugging
            hasCompletedOnboarding = false
        }
    }
}

#Preview {
    ContentView()
}
