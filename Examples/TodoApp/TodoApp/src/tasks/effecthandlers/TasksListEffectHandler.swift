import Foundation
import MobiusCore

final class TasksListEffectHandler: Connectable {
    weak var viewModel: TasksListViewModeling?

    // MARK: - Connectable

    func connect(_ eventConsumer: @escaping Consumer<TasksList.Event>) -> Connection<TasksList.Effect> {
        return Connection<TasksList.Effect>(
            acceptClosure: routeEffect,
            disposeClosure: { /* Nothing to dispose */ }
        )
    }

    // MARK: - Private

    private func routeEffect(_ effect: TasksList.Effect) {
        switch effect {
        case .loadTasks:
            viewModel?.loadTasks()
        case .saveTask(let task):
            viewModel?.save(task: task)
        case .startTaskCreationFlow:
            viewModel?.showAddTaskModal()
        }
    }
}
