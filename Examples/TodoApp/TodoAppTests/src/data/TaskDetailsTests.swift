import XCTest
@testable import TodoApp

class TaskDetailsTests: XCTestCase {

    func testIsEqual_differentTitles_returnsFalse() {
        let taskDetails = TaskDetails(title: "1")
        let taskDetails2 = TaskDetails(title: "2")

        XCTAssertNotEqual(taskDetails, taskDetails2)
    }

    func testIsEqual_differentDescriptions_returnsFalse() {
        let taskDetails = TaskDetails(title: "1", description: "d1")
        let taskDetails2 = TaskDetails(title: "1", description: "d2")

        XCTAssertNotEqual(taskDetails, taskDetails2)
    }

    func testIsEqual_differentIsCompleted_returnsFalse() {
        let taskDetails = TaskDetails(title: "1", description: "d1", isCompleted: true)
        let taskDetails2 = TaskDetails(title: "1", description: "d1", isCompleted: false)

        XCTAssertNotEqual(taskDetails, taskDetails2)
    }

    func testIsEqual_sameObjects_returnsTrue() {
        let taskDetails = TaskDetails(title: "1", description: "d1", isCompleted: true)
        let taskDetails2 = TaskDetails(title: "1", description: "d1", isCompleted: true)

        XCTAssertEqual(taskDetails, taskDetails2)
    }

}
