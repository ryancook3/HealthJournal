//
//  RecapStatsView.swift
//  HealthJournal
//
//  Created by Ryan Cook on 6/2/25.
//
import SwiftUI

struct RecapStatsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                // AI Recap Section
                InsightsSection(title: "AI Recap", icon: "sparkles") {
                    Text("You walked more than usual and had a good sleep. Keep up the great work! \n\nMood was positive 5/7 days. Try to get to bed before 11pm for even better rest.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                // Health Trends Section
                InsightsSection(title: "Health Trends", icon: "chart.line.uptrend.xyaxis") {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 16) {
                            StatCard(icon: "figure.walk", value: "6,721", label: "Steps", gradient: Gradient(colors: [.blue, .green]))
                            StatCard(icon: "bed.double.fill", value: "7.2", label: "Sleep (hrs)", gradient: Gradient(colors: [.purple, .indigo]))
                            StatCard(icon: "heart.fill", value: "73", label: "BPM", gradient: Gradient(colors: [.pink, .red]))
                        }
                        .padding(.top, 4)
                        // Placeholder for future charts/graphs
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray5).opacity(0.7))
                            .frame(height: 80)
                            .overlay(Text("[Trend Graphs Here]").foregroundColor(.secondary))
                            .padding(.top, 8)
                    }
                }
                // Goals Section
                InsightsSection(title: "Goals", icon: "target") {
                    VStack(alignment: .leading, spacing: 16) {
                        GoalCard(title: "Walk 7,000 steps/day", progress: 0.8, color: .green)
                        GoalCard(title: "Sleep 7+ hours", progress: 0.6, color: .purple)
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Goal")
                                    .fontWeight(.semibold)
                            }
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor.opacity(0.12))
                            .cornerRadius(10)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding()
        }
    }
}

struct InsightsSection<Content: View>: View {
    let title: String
    let icon: String
    let content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.accentColor)
                Text(title)
                    .font(.headline)
            }
            content()
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.9))
        .cornerRadius(16)
        .shadow(color: Color.primary.opacity(0.06), radius: 6, x: 0, y: 2)
    }
}

struct GoalCard: View {
    let title: String
    let progress: Double // 0.0 to 1.0
    let color: Color
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
            ProgressView(value: progress)
                .accentColor(color)
                .frame(height: 8)
                .scaleEffect(x: 1, y: 1.2, anchor: .center)
            Text("\(Int(progress * 100))% complete")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(10)
        .background(color.opacity(0.08))
        .cornerRadius(10)
    }
}

struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let gradient: Gradient

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.title2)
            }
            Text(value)
                .font(.title2)
                .bold()
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6).opacity(0.9))
        .cornerRadius(14)
        .shadow(color: Color.primary.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    RecapStatsView()
}
