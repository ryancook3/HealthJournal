import Foundation
import SwiftUI

enum GoalType: String, Codable, CaseIterable {
    case boolean // e.g., "Did you take creatine?"
    case numeric // e.g., "Walk 7,000 steps"
}

struct Goal: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: GoalType
    var targetValue: Double? // Only for numeric goals
    var colorHex: String // Store color as hex string for Codable
    var icon: String // SF Symbol name
    // Log of completions: [dateString: value]
    var log: [String: Double]

    init(
        id: UUID = UUID(),
        name: String,
        type: GoalType,
        targetValue: Double? = nil,
        color: Color = .accentColor,
        icon: String = "target",
        log: [String: Double] = [:]
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.targetValue = targetValue
        self.colorHex = color.toHex() ?? "#007AFF"
        self.icon = icon
        self.log = log
    }
    var color: Color {
        Color(hex: colorHex)
    }
}

// Helpers for Color <-> Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 122, 255)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    func toHex() -> String? {
        let uiColor = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format: "#%06x", rgb)
    }
} 