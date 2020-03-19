import Foundation
import MobiusCore

final class TasksListEffectHandler: Connectable {

    // MARK: - Connectable

    func connect(_ eventConsumer: @escaping Consumer<TasksList.Event>) -> Connection<TasksList.Effect> {
        return Connection<TasksList.Effect>(
            acceptClosure: routeEffect,
            disposeClosure: {
                // Nothing to dispose
            }
        )
    }

    // MARK: - Private

    private func routeEffect(_ effect: TasksList.Effect) {
        switch effect {
        case .loadTasks: print("load task effect")
        case .saveTask(let task): print("save task \(task) effect")
        case .startTaskCreationFlow: print("start task effect") // TODO: Delegate to view (present(addTaskModal, animated: true, completion: nil))
        }
    }
}
