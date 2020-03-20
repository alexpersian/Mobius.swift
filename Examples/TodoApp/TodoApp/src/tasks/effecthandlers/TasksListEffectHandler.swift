import Foundation
import MobiusCore
import UIKit

final class TasksListEffectHandler: Connectable {

    weak var view: (UIViewController & TaskViewing)?

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
        case .loadTasks:
            //TODO: show spinner
            print("load task effect")
        case .saveTask(let task): print("save task \(task) effect")
        case .startTaskCreationFlow:
            view?.showAddTaskModal()
        }
    }
}
