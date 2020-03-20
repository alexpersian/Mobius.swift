import Foundation

struct TasksList {
    struct Model {
        let tasks: [Task]
        let loading: Bool
    }

    enum Event {
        case refreshRequested
        case tasksLoaded(tasks: [Task])
        case newTaskClicked
        case taskCreated(title: String, description: String)
    }

    enum Effect {
        case loadTasks
        case saveTask(task: Task)
        case startTaskCreationFlow
    }
}
