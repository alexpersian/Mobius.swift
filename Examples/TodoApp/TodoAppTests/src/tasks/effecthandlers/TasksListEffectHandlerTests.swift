import XCTest
@testable import TodoApp
import MobiusCore

final class TasksListEffectHandlerTests: XCTestCase {

    private var subject: TasksListEffectHandler!

    override func setUp() {
        super.setUp()
        subject = TasksListEffectHandler()
    }

    override func tearDown() {
        subject = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testConnect() {
        let connection = subject.connect { event in

        }

    }
}

