import Foundation
import MobiusCore

final class TasksListEffectHandler: Connectable {

    // MARK: - Connectable

    func connect(_ eventConsumer: @escaping Consumer<TasksListEvent>) -> Connection<TasksListEffect> {
        return Connection<TasksListEffect>(
            acceptClosure: routeEffect,
            disposeClosure: {
                // Nothing to dispose
            }
        )
    }

    // MARK: - Private

    private func routeEffect(_ effect: TasksListEffect) {
        switch effect {
        case .loadTasks: print("load task effect")
        case .saveTask(let task): print("save task \(task) effect")
        case .startTaskCreationFlow: print("start task effect")
        }
    }
}
