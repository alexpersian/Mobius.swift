import Foundation

struct Task {
    private let id: String
    private var details: TaskDetails

    var isCompleted: Bool {
        willSet {
            details.isCompleted = isCompleted
        }
    }

    var isActive: Bool
}
