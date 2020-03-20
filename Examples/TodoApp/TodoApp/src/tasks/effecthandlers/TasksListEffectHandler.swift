import Foundation
import MobiusCore

final class TasksListEffectHandler: Connectable {
    weak var viewModel: TasksListViewModeling?
    private let dataSource: TasksDataSource

    init(dataSource: TasksDataSource = TaskRemoteDataSource()) {
         self.dataSource = dataSource
     }
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
        case .loadTasks: handleLoadTasks()
        case .saveTask(let task):
            dataSource.save(task: task)
        case .startTaskCreationFlow:
            viewModel?.showAddTaskModal()
        }
    }

    private func handleLoadTasks() {
        view?.displaySpinner(true)
        dataSource.fetchTasks { tasks in

        }
    }
}
