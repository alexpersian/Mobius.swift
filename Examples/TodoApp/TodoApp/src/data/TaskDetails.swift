import Foundation

struct TaskDetails: Equatable {
    let title: String
    let description: String
    var isCompleted: Bool

    init(title: String = "", description: String = "", isCompleted: Bool = false) {
        self.title = title
        self.description = description
        self.isCompleted = isCompleted
    }

    // MARK: - Equatable
    static func == (lhs: TaskDetails, rhs: TaskDetails) -> Bool {
        return lhs.title == rhs.title && lhs.description == rhs.description && lhs.isCompleted == rhs.isCompleted
    }
}
