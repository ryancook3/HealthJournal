import Foundation

struct HealthStat: Identifiable, Codable {
    let id: UUID
    var name: String
    var icon: String
    var value: String
    var isVisible: Bool
    var order: Int

    init(id: UUID = UUID(), name: String, icon: String, value: String, isVisible: Bool = true, order: Int) {
        self.id = id
        self.name = name
        self.icon = icon
        self.value = value
        self.isVisible = isVisible
        self.order = order
    }
} 