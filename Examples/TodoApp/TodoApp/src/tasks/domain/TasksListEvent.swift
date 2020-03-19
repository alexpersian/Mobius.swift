import Foundation

enum TasksListEvent {
    case newTaskClicked
    case tasksLoaded(tasks: [Task])
    case taskCreated
}
