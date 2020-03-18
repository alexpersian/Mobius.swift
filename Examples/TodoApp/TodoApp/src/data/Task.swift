import Foundation

struct Task: Equatable {
    let id: String
    var details: TaskDetails

    var isCompleted: Bool {
        willSet {
            details.isCompleted = isCompleted
        }
    }

    var isActive: Bool

    init(id: String = "", details: TaskDetails) {
        self.id = id
        self.details = details
        isCompleted = false
        isActive = false
    }

    // MARK: - Equatable
    
    static func == (lhs: Task, rhs: Task) -> Bool {
        return lhs.id == rhs.id && lhs.details == rhs.details
    }
}
