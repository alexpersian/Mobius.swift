import Foundation

final class TaskLocalDataSource: TasksDataSource {
    private let tasksKey = "TaskLocalDataSourceTasks"

    // MARK: - TasksDataSource

    func fetchTasks(_ completion: @escaping ([Task]) -> ()) {
        guard let tasks = UserDefaults.standard.object(forKey: tasksKey) as? Data else {
            completion([])
            return
        }
        completion(decode(tasks))
    }

    func task(for id: String, completion: @escaping (Task?) -> ()) {
        fetchTasks { tasks in
            guard let task = (tasks.first { $0.id == id })  else { completion(nil); return }
            completion(task)
        }
    }

    func save(task: Task) {
        fetchTasks { [weak self] tasks in
            guard let self = self else { return }
            let newTasks = tasks + [task]
            let encodedTasks = self.encode(newTasks)
            UserDefaults.standard.set(encodedTasks, forKey: self.tasksKey)
         }
    }

    func deleteAllTasks() {
        UserDefaults.standard.removeObject(forKey: tasksKey)
    }

    func deleteTask(for id: String) {
        fetchTasks { [weak self] tasks in
            guard let self = self else { return }
            let newTasks = tasks.filter { $0.id != id }
            let encodedTasks = self.encode(newTasks)
            UserDefaults.standard.set(encodedTasks, forKey: self.tasksKey)
        }
    }

    // MARK: - Private

    private func encode(_ tasks: [Task]) -> Data? {
        return try? JSONEncoder().encode(tasks)
    }

    private func decode(_ tasksData: Data) -> [Task] {
        guard let decoded = try? JSONDecoder().decode([Task].self, from: tasksData) else { return [] }
        return decoded
    }
}
