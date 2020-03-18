import Foundation

/// Implementation of the data source that adds a latency simulating network.
/// Allows concurrent reads and one write at a time to taskServiceData,

class TaskRemoteDataSource: TasksDataSource {

    private var taskServiceData: [String: Task]
    private let dispatchQueueExecutor: DispatchQueueExecutor

    init(dispatchQueueExecutor: DispatchQueueExecutor = DispatchQueueExecutor()) {
        self.dispatchQueueExecutor = dispatchQueueExecutor
        taskServiceData =
            ["1234": Task(id: "1234", details: TaskDetails(title: "Build tower in Pisa", description: "Ground looks good, no foundation work required.")),
            "4321": Task(id: "4321", details: TaskDetails(title: "Finish bridge in Tacoma", description: "Found awesome girders at half the cost!"))]
    }

    // MARK: - TasksDataSource

    func fetchTasks(_ completion: @escaping ([Task]) -> ()) {
        dispatchQueueExecutor.syncAfter(dispatchTime: makeDelayedDispatchTime(), { [weak self] in
            guard let self = self else { completion([]); return }
            let tasks = Array(self.taskServiceData.values)
            DispatchQueue.main.async {
                completion(tasks)
            }
        })
    }

    func task(for id: String, completion: @escaping (Task?) -> ()) {
        dispatchQueueExecutor.syncAfter(dispatchTime: makeDelayedDispatchTime(), { [weak self] in
            guard let self = self else { completion(nil); return }
            DispatchQueue.main.async { [weak self] in
                completion(self?.taskServiceData[id])
            }
        })
    }

    func save(task: Task) {
        dispatchQueueExecutor.asyncAfter(dispatchTime: makeDelayedDispatchTime(), flags: .barrier, { [weak self] in
            self?.taskServiceData[task.id] = task
        })
    }

    func deleteAllTasks() {
        dispatchQueueExecutor.asyncAfter(dispatchTime: makeDelayedDispatchTime(), flags: .barrier, { [weak self] in
            self?.taskServiceData.removeAll()
        })
    }

    func deleteTask(for id: String) {
        dispatchQueueExecutor.asyncAfter(dispatchTime: makeDelayedDispatchTime(), flags: .barrier, { [weak self] in
            self?.taskServiceData.removeValue(forKey: id)
        })
    }

    // MARK: - Private

    private func makeDelayedDispatchTime() -> DispatchTime {
        // Simulate network delay of 1 seconds
        return DispatchTime.now() + 1
    }
}
