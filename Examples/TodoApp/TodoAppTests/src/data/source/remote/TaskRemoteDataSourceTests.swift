import XCTest
@testable import TodoApp

class TaskRemoteDataSourceTests: XCTestCase {
    private var subject: TaskRemoteDataSource!
    private let pisaTask = Task(id: "1234", details: TaskDetails(title: "Build tower in Pisa", description: "Ground looks good, no foundation work required."))
    private let tacomaTask = Task(id: "4321", details: TaskDetails(title: "Finish bridge in Tacoma", description: "Found awesome girders at half the cost!"))

    override func setUp() {
        super.setUp()
        let dispatchQueueExecutor = DispatchQueueExecutor(queue: DispatchQueue.main, isUnitTest: true)
        subject = TaskRemoteDataSource(dispatchQueueExecutor: dispatchQueueExecutor)
    }

    override func tearDown() {
        subject = nil
        super.tearDown()
    }

    func testFetchTasks_returnsHarcodedTasks() {
        let fetchCompleted = expectation(description: "fetch tasks completes")
        let expectedTasks = [pisaTask, tacomaTask]

        subject.fetchTasks { tasks in
            XCTAssertEqual(tasks.count, 2)
            let sortedTasks = tasks.sorted { (l, r) -> Bool in l.id < r.id }
            XCTAssertEqual(sortedTasks, expectedTasks)
            fetchCompleted.fulfill()
        }
        wait(for: [fetchCompleted], timeout: 1.0)
    }

    func testFetchTaskForId_whenNoTask_completesWithNil() {
        let fetchCompleted = expectation(description: "fetch tasks completes")

        subject.task(for: "unknown") { task in
            XCTAssertNil(task)
            fetchCompleted.fulfill()
        }

        wait(for: [fetchCompleted], timeout: 1.0)
    }

    func testFetchTaskForId_whenTaskExists_completesWithTask() {
        let fetchCompleted = expectation(description: "fetch tasks completes")

        subject.task(for: "1234") { task in
            XCTAssertEqual(task, self.pisaTask)
            fetchCompleted.fulfill()
        }

        wait(for: [fetchCompleted], timeout: 1.0)
    }

    func testSaveTask() {
        let newTask = Task(id: "1", details: TaskDetails(title: "foo", description: "bar", isCompleted: true))
        subject.save(task: newTask)

        let fetchCompleted = expectation(description: "fetch tasks completes")
        subject.task(for: "1") { task in
            XCTAssertEqual(task, newTask)
            fetchCompleted.fulfill()
        }

        wait(for: [fetchCompleted], timeout: 1.0)
    }

    func testDeleteAllTasks() {
        subject.deleteAllTasks()

        let fetchCompleted = expectation(description: "fetch tasks completes")
        subject.fetchTasks { tasks in
            XCTAssertEqual(tasks.count, 0)
            fetchCompleted.fulfill()
        }

        wait(for: [fetchCompleted], timeout: 1.0)
    }

    func testDeleteTaskForId() {
        subject.deleteTask(for: "1234")

        let fetchCompleted = expectation(description: "fetch tasks completes")
        subject.fetchTasks { tasks in
            XCTAssertEqual(tasks, [self.tacomaTask])
            fetchCompleted.fulfill()
        }

        wait(for: [fetchCompleted], timeout: 1.0)
    }

}
