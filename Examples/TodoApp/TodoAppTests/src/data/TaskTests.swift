import XCTest
@testable import TodoApp

class TaskTests: XCTestCase {

    func testIsEqual_differentIds_returnsFalse() {
        let task = Task(id: "1", details: TaskDetails())
        let task2 = Task(id: "2", details: TaskDetails())

        XCTAssertNotEqual(task, task2)
    }

    func testIsEqual_differentIsCompleted_returnsFalse() {
        var task = Task(id: "1", details: TaskDetails())
        var task2 = Task(id: "1", details: TaskDetails())
        task.isCompleted = true
        task2.isCompleted = false

        XCTAssertNotEqual(task, task2)
    }

    func testIsEqual_differentIsActive_returnsFalse() {
        var task = Task(id: "1", details: TaskDetails())
        var task2 = Task(id: "1", details: TaskDetails())
        task.isActive = true
        task2.isActive = false

        XCTAssertNotEqual(task, task2)
    }

    func testIsEqual_sameTasks_returnsTrue() {
        let task = Task(id: "1", details: TaskDetails())
        let task2 = Task(id: "1", details: TaskDetails())

        XCTAssertEqual(task, task2)
    }
}
