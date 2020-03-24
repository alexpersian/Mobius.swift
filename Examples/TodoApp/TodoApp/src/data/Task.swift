import Foundation

struct Task: Codable, Equatable {
    let id: String
    var details: TaskDetails

    var isCompleted: Bool {
        willSet {
            details.isCompleted = isCompleted
        }
    }

    var isActive: Bool

    init(id: String = UUID().uuidString, details: TaskDetails) {
        self.id = id
        self.details = details
        isCompleted = false
        isActive = false
    }
}
