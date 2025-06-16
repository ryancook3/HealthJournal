//
//  AddEntryView.swift
//  HealthJournal
//
//  Created by Ryan Cook on 6/1/25.
//

import SwiftUI

struct AddEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var entryText = ""
    @State private var useTemplate = false
    @State private var selectedTemplate: JournalTemplate?
    @State private var showingTemplatePicker = false
    @State private var showCustomize = false
    
    private let healthSnippet = """
Steps: 6721
Heart Rate: 73 bpm
Sleep: 7.2 hrs
"""
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.accentColor.opacity(0.15), Color.purple.opacity(0.10)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                Circle()
                    .fill(Color.accentColor.opacity(0.12))
                    .frame(width: 260, height: 260)
                    .offset(x: 120, y: -180)
                VStack(spacing: 0) {
                    // Integrated Health Stats Header
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            StatPill(value: "6,721", label: "Steps", icon: "figure.walk")
                            StatPill(value: "73", label: "BPM", icon: "heart.fill")
                            StatPill(value: "7.2", label: "Sleep", icon: "bed.double.fill")
                            StatPill(value: "2,450", label: "Calories", icon: "flame.fill")
                            StatPill(value: "68", label: "Weight (lbs)", icon: "scalemass.fill")
                            StatPill(value: "85%", label: "Energy", icon: "battery.100")
                        }
                        .padding(.horizontal)
                        .padding(.top, 12)
                    }
                    .background(Color.clear)

                    // Show template prompts if selected
                    if let template = selectedTemplate, useTemplate {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Prompts:")
                                .font(.headline)
                                .padding(.bottom, 2)
                            ForEach(template.prompts, id: \.self) { prompt in
                                HStack(alignment: .top) {
                                    Text("•")
                                    Text(prompt)
                                }
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }

                    // Entry Editor (main focus)
                    ZStack(alignment: .topLeading) {
                        if entryText.isEmpty {
                            Text("Start writing your journal entry...")
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 18)
                                .padding(.top, 18)
                        }
                        TextEditor(text: $entryText)
                            .font(.body)
                            .padding(12)
                            .frame(maxHeight: .infinity)
                            .background(Color(.systemBackground))
                            .cornerRadius(0)
                    }
                    .padding(.horizontal)
                    .padding(.bottom)

                    // Template Picker (optional, at the bottom)
                    if useTemplate {
                        Button {
                            showingTemplatePicker = true
                        } label: {
                            HStack {
                                Text(selectedTemplate?.name ?? "Select Template")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6).opacity(0.9))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: { showCustomize = true }) {
                            Image(systemName: "gearshape")
                        }
                        Button("Save") {
                            // Save logic
                            dismiss()
                        }
                        .bold()
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Toggle(isOn: $useTemplate.animation(.easeInOut)) {
                        Label("Use Template", systemImage: "doc.text")
                    }
                    .padding(.horizontal)
                }
            }
            .sheet(isPresented: $showingTemplatePicker) {
                TemplateSelectionView(selectedTemplate: $selectedTemplate)
            }
            .sheet(isPresented: $showCustomize) {
                CustomizeStatsView()
            }
            .preferredColorScheme(colorScheme)
        }
    }
}

struct StatPill: View {
    let value: String
    let label: String
    let icon: String
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundColor(.accentColor)
            Text(value)
                .font(.subheadline)
                .bold()
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct JournalTemplate: Identifiable {
    let id = UUID()
    let name: String
    let prompts: [String]
}

#Preview {
    AddEntryView()
        .preferredColorScheme(.dark)
}
