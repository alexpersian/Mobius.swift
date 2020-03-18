import Foundation

protocol TasksDataSource {
    func fetchTasks(_ completion: @escaping ([Task]) -> ())
    func task(for id: String, completion: @escaping (Task?) -> ())
    func save(task: Task)
    func deleteAllTasks()
    func deleteTask(for id: String)
}
