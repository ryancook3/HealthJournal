import SwiftUI

struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var showAddEntry = false
    // Mock data: entries by date (yyyy-MM-dd)
    let entriesByDate: [String: [String]] = [
        "2025-06-01": ["Morning walk and meditation.", "Ate healthy breakfast."],
        "2025-06-02": ["Read a book before bed.", "Went for a run."]
    ]
    // Helper to get all marked dates
    var markedDates: Set<String> {
        Set(entriesByDate.keys)
    }
    // Helper to format date as yyyy-MM-dd
    func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    // Helper to get entries for selected date
    var entriesForSelectedDate: [String] {
        entriesByDate[dateString(selectedDate)] ?? []
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 24) {
                // Modern Calendar Grid
                CalendarGrid(selectedDate: $selectedDate, markedDates: markedDates)
                    .padding(.horizontal)
                // Entries for Selected Date
                VStack(alignment: .leading, spacing: 12) {
                    Text("Entries for \(formattedDate(selectedDate))")
                        .font(.headline)
                        .padding(.bottom, 2)
                    if entriesForSelectedDate.isEmpty {
                        HStack {
                            Image(systemName: "doc.text")
                                .foregroundColor(.secondary)
                            Text("No entries for this day.")
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, minHeight: 80, alignment: .center)
                    } else {
                        ForEach(entriesForSelectedDate, id: \ .self) { entry in
                            CalendarEntryCard(entry: entry)
                        }
                    }
                }
                .padding()
                .frame(minHeight: 120, maxHeight: 220, alignment: .top)
                .background(Color(.systemGray6).opacity(0.9))
                .cornerRadius(16)
                .shadow(color: Color.primary.opacity(0.06), radius: 6, x: 0, y: 2)
                .padding(.horizontal)
            }
            .padding(.top)
            // Floating Add Button
            Button(action: { showAddEntry = true }) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color(.black))
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(Circle())
                    .shadow(color: Color.accentColor.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding()
            .fullScreenCover(isPresented: $showAddEntry) {
                AddEntryView()
            }
        }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct CalendarEntryCard: View {
    let entry: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "note.text")
                .font(.title3)
                .foregroundColor(.accentColor)
                .padding(.top, 2)
            Text(entry)
                .font(.body)
                .foregroundColor(.primary)
                .padding(.vertical, 6)
            Spacer()
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color(.systemBackground).opacity(0.85))
        .cornerRadius(12)
        .shadow(color: Color.primary.opacity(0.04), radius: 2, x: 0, y: 1)
    }
}

struct CalendarGrid: View {
    @Binding var selectedDate: Date
    let markedDates: Set<String>
    // Calendar grid helpers
    let calendar = Calendar.current
    let days = ["S", "M", "T", "W", "T", "F", "S"]
    var currentMonth: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: selectedDate)) ?? Date()
    }
    var daysInMonth: Int {
        calendar.range(of: .day, in: .month, for: currentMonth)?.count ?? 30
    }
    var firstWeekday: Int {
        calendar.component(.weekday, from: currentMonth) - 1 // 0 = Sunday
    }
    func dayDate(_ day: Int) -> Date? {
        calendar.date(byAdding: .day, value: day - 1, to: currentMonth)
    }
    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
    func isSelected(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }
    func isMarked(_ date: Date) -> Bool {
        markedDates.contains(dateString(date))
    }
    func dateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    var body: some View {
        VStack(spacing: 8) {
            // Month/Year header
            HStack {
                Text(monthYearString(currentMonth))
                    .font(.headline)
                Spacer()
            }
            // Day labels
            HStack {
                ForEach(days, id: \ .self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.secondary)
                }
            }
            // Calendar grid
            let totalDays = daysInMonth + firstWeekday
            let rows = Int(ceil(Double(totalDays) / 7.0))
            ForEach(0..<rows, id: \ .self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<7, id: \ .self) { col in
                        let day = row * 7 + col - firstWeekday + 1
                        if row == 0 && col < firstWeekday || day < 1 || day > daysInMonth {
                            Spacer().frame(maxWidth: .infinity)
                        } else if let date = dayDate(day) {
                            Button(action: { selectedDate = date }) {
                                ZStack {
                                    if isSelected(date) {
                                        Circle()
                                            .fill(LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                                            .frame(width: 36, height: 36)
                                    } else if isToday(date) {
                                        Circle()
                                            .stroke(Color.accentColor, lineWidth: 2)
                                            .frame(width: 36, height: 36)
                                    }
                                    Text("\(calendar.component(.day, from: date))")
                                        .font(.body)
                                        .foregroundColor(isSelected(date) ? .white : .primary)
                                    if isMarked(date) {
                                        Circle()
                                            .fill(Color.accentColor)
                                            .frame(width: 6, height: 6)
                                            .offset(y: 14)
                                    }
                                }
                                .frame(maxWidth: .infinity, minHeight: 44)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
        .padding(12)
        .background(Color(.systemGray6).opacity(0.9))
        .cornerRadius(16)
        .shadow(color: Color.primary.opacity(0.06), radius: 6, x: 0, y: 2)
    }
    func monthYearString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    CalendarView()
}
