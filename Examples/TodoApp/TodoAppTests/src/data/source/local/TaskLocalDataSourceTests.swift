import XCTest
@testable import TodoApp

class TaskLocalDataSourceTests: XCTestCase {
    private var subject: TaskLocalDataSource!
    private let task = Task(id: "1", details: TaskDetails(title: "foo", description: "bar"))
    private let task2 = Task(id: "2", details: TaskDetails(title: "foo2", description: "bar2"))

    override func setUp() {
        super.setUp()
        subject = TaskLocalDataSource()
    }

    override func tearDown() {
        subject.deleteAllTasks()
        subject = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_fetchTask_returnsSavedTask() {
        subject.save(task: task)
        subject.task(for: task.id) { fetchedTask in
            XCTAssertEqual(self.task, fetchedTask)
        }
    }

    func test_fetchTasks_returnsSavedTasks() {
        subject.save(task: task)
        subject.save(task: task2)

        subject.fetchTasks { fetchedTask in
            let sortedTasks = fetchedTask.sorted { l, r in l.id < r.id }
            XCTAssertEqual([self.task, self.task2], sortedTasks)
        }
    }

    func test_deleteAllTracks_returnsEmptyArray() {
        subject.save(task: task)
        subject.save(task: task2)

        subject.deleteAllTasks()

        subject.fetchTasks { fetchedTask in
            XCTAssertEqual([], fetchedTask)
        }
    }

    func test_deleteTask_deletesTask() {
        subject.save(task: task)
        subject.save(task: task2)

        subject.deleteTask(for: task.id)

        subject.fetchTasks { fetchedTask in
            XCTAssertEqual([self.task2], fetchedTask)
        }
    }
}
