import SwiftUI

struct MainJournalView: View {
    @State private var searchText = ""
    @Environment(\.colorScheme) var colorScheme
    @State private var showAddEntry = false
    @State private var animateAdd = false
    @State private var selectedTab = 0 // 0 = Journal, 1 = Calendar
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 0) {
                    Picker("View", selection: $selectedTab) {
                        Text("Journal").tag(0)
                        Text("Calendar").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding([.horizontal, .top])

                    if selectedTab == 0 {
                        ScrollView {
                            VStack(spacing: 20) {
                                // Search Bar
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.secondary)
                                    TextField("Search entries", text: $searchText)
                                        .textFieldStyle(PlainTextFieldStyle())
                                }
                                .padding(10)
                                .background(Color(.systemGray6).opacity(0.9))
                                .cornerRadius(10)
                                .padding([.horizontal, .top])

                                // Journal Entries
                                ForEach(0..<5) { index in
                                    NavigationLink(destination: JournalEntryDetailView()) {
                                        JournalEntryRow()
                                            .padding(.horizontal)
                                    }
                                }
                            }
                            .padding(.bottom, 80)
                        }
                    } else {
                        CalendarView()
                    }
                }
                // Floating Add Button with fade-in
                Button(action: { showAddEntry = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .clipShape(Circle())
                        .shadow(color: colorScheme == .dark ? Color.black.opacity(0.4) : Color.accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
                        .opacity(animateAdd ? 1 : 0)
                        .animation(.easeIn(duration: 1.0), value: animateAdd)
                        .onAppear { animateAdd = true }
                }
                .padding()
                .fullScreenCover(isPresented: $showAddEntry) {
                    AddEntryView()
                }
            }
            .navigationTitle(selectedTab == 0 ? "My Journal" : "Calendar")
        }
        .onChange(of: selectedTab) { newTab in
            if newTab == 0 {
                searchText = ""
            }
        }
    }
}

struct JournalEntryRow: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Today's Entry")
                    .font(.headline)
                Spacer()
                Text("6/2/25")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Text("Steps: 6,721 • Heart Rate: 73 bpm • Sleep: 7.2 hrs")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Started my day with a morning walk...")
                .font(.body)
                .lineLimit(2)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.9))
        .cornerRadius(14)
        .shadow(color: Color.primary.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}

struct JournalEntryDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var entryText: String = ""
    @State private var showSaved = false
    let entryID: String = "demo-entry-1" // Replace with real entry ID in a real app
    var body: some View {
        VStack(spacing: 0) {
            // Integrated Health Stats Header
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    StatPill(value: "6,721", label: "Steps", icon: "figure.walk")
                    StatPill(value: "73", label: "BPM", icon: "heart.fill")
                    StatPill(value: "7.2", label: "Sleep", icon: "bed.double.fill")
                    StatPill(value: "2,450", label: "Calories", icon: "flame.fill")
                    StatPill(value: "68", label: "Weight (lbs)", icon: "scalemass.fill")
                    StatPill(value: "85%", label: "Energy", icon: ".75.fill")
                }
                .padding(.horizontal)
                .padding(.top, 12)
            }
            .background(Color(.systemGroupedBackground))

            // Editable Entry Content
            ZStack(alignment: .topLeading) {
                if entryText.isEmpty {
                    Text("Start writing your journal entry...")
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 18)
                        .padding(.top, 18)
                }
                TextEditor(text: $entryText)
                    .font(.body)
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .onChange(of: entryText) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "entryText_\(entryID)")
                    }
            }
            .background(Color(.systemGroupedBackground))
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Journal Entry")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") { presentationMode.wrappedValue.dismiss() }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    // Save logic here
                    showSaved = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        showSaved = false
                    }
                }
                .bold()
            }
        }
        .overlay(
            Group {
                if showSaved {
                    Text("Saved!")
                        .font(.headline)
                        .padding(12)
                        .background(Color.accentColor.opacity(0.95))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 8)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }, alignment: .top
        )
        .onAppear {
            if let saved = UserDefaults.standard.string(forKey: "entryText_\(entryID)") {
                entryText = saved
            } else {
                entryText = "Started my day with a morning walk. Felt energized and focused throughout work. Had a healthy lunch and read before bed."
            }
        }
    }
}

struct CustomizeStatsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var stats: [HealthStat] = [
        HealthStat(name: "Steps", icon: "figure.walk", value: "6,721", isVisible: true, order: 0),
        HealthStat(name: "BPM", icon: "heart.fill", value: "73", isVisible: true, order: 1),
        HealthStat(name: "Sleep", icon: "bed.double.fill", value: "7.2", isVisible: true, order: 2),
        HealthStat(name: "Calories", icon: "flame.fill", value: "2,450", isVisible: false, order: 3),
        HealthStat(name: "Weight (lbs)", icon: "scalemass.fill", value: "68", isVisible: true, order: 4),
        HealthStat(name: "Energy", icon: "battery.100.fill", value: "85%", isVisible: false, order: 5)
    ]
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Live preview
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(stats.filter { $0.isVisible }.sorted(by: { $0.order < $1.order })) { stat in
                            StatPill(value: stat.value, label: stat.name, icon: stat.icon)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                }
                .background(Color.clear)
                // Customization list
                List {
                    ForEach($stats) { $stat in
                        HStack {
                            Image(systemName: stat.icon)
                                .foregroundColor(.accentColor)
                            Text(stat.name)
                            Spacer()
                            Toggle("", isOn: $stat.isVisible)
                                .labelsHidden()
                                .tint(.blue)
                        }
                        .padding(8)
                        .background(Color(.systemGray5).opacity(0.7))
                        .cornerRadius(10)
                    }
                    .onMove { indices, newOffset in
                        stats.move(fromOffsets: indices, toOffset: newOffset)
                        // Update order after move
                        for i in stats.indices { stats[i].order = i }
                    }
                }
                .environment(\.editMode, .constant(.active))
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Customize Stats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct HealthStatsSummary: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Health Summary")
                .font(.headline)
            
            HStack(spacing: 20) {
                StatView(value: "6,721", label: "Steps", icon: "figure.walk")
                StatView(value: "73", label: "BPM", icon: "heart.fill")
                StatView(value: "7.2", label: "Hours", icon: "bed.double.fill")
                StatView(value: "68", label: "Weight (lbs)", icon: "scalemass.fill")
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct StatView: View {
    let value: String
    let label: String
    let icon: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    MainJournalView()
}
