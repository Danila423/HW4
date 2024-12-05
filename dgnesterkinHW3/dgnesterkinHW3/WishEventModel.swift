import Foundation

struct WishEventModel: Codable, Identifiable {
    // MARK: - Properties
    let id: UUID
    let title: String
    let description: String
    let startDate: Date
    let endDate: Date

    // MARK: - Initialization
    init(id: UUID = UUID(), title: String, description: String, startDate: Date, endDate: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
    }
}
