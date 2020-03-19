import Foundation

enum TasksListEffect {
    case loadTasks
    case saveTask(task: Task)
    case startTaskCreationFlow
}
