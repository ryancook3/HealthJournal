import SwiftUI

struct JournalEntry: Identifiable {
    let id = UUID()
    let date: Date
    let content: String
}

struct JournalListView: View {
    let entries = [
        JournalEntry(date: ISO8601DateFormatter().date(from: "2025-05-30T00:00:00Z")!, content: "Felt productive today, had a great workout."),
        JournalEntry(date: ISO8601DateFormatter().date(from: "2025-05-29T00:00:00Z")!, content: "Struggled to sleep, but did some journaling to calm down.")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(entries) { entry in
                    HStack(alignment: .top, spacing: 12) {
                        VStack(spacing: 2) {
                            Text(formattedMonth(entry.date))
                                .font(.caption2)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                            Text(formattedDay(entry.date))
                                .font(.title3)
                                .bold()
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .frame(width: 50)

                        VStack(alignment: .leading, spacing: 8) {
                            Text(entry.content)
                                .font(.body)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(LinearGradient(
                        gradient: Gradient(colors: [Color("CardGradientStart"), Color("CardGradientEnd")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 4)
                    .padding(.horizontal)
                }
            }
            .padding(.top)
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
    }

    func formattedMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: date).uppercased()
    }

    func formattedDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}
