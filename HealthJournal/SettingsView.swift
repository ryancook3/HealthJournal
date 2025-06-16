//
//  SettingsView.swift
//  HealthJournal
//
//  Created by Ryan Cook on 6/2/25.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account")) {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(.blue)
                        Text("Profile")
                    }
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.orange)
                        Text("Privacy")
                    }
                }
                .listRowBackground(Color(.systemGray6).opacity(0.9))
                .cornerRadius(14)
                Section(header: Text("Notifications")) {
                    Toggle(isOn: .constant(true)) {
                        Label("Daily Reminders", systemImage: "bell.fill")
                    }
                }
                .listRowBackground(Color(.systemGray6).opacity(0.9))
                .cornerRadius(14)
                Section(header: Text("Appearance")) {
                    HStack {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.purple)
                        Text("Dark Mode")
                        Spacer()
                        Text("System")
                            .foregroundColor(.secondary)
                    }
                }
                .listRowBackground(Color(.systemGray6).opacity(0.9))
                .cornerRadius(14)
            }
            .background(Color.clear)
            .scrollContentBackground(.hidden)
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
