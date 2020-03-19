import Foundation

struct TasksList {
    struct Model {
        let tasks: [Task]
        let loading: Bool
    }

    enum Event {
        case newTaskClicked
        case tasksLoaded(tasks: [Task])
    }

    enum Effect {
        case loadTasks
        case saveTask(task: Task)
        case startTaskCreationFlow
    }
}
