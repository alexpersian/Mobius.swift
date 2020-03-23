import XCTest
@testable import TodoApp
import MobiusCore

final class TaskListViewModelTests: XCTestCase {

    private var subject: TasksListViewModel!

    private var effectHandler: TasksListEffectHandler!
    private var mockTasksDataSource: MockTasksDataSource!
    private var mockEventConsumer: MockEventConsumer!

    override func setUp() {
        super.setUp()
        effectHandler = TasksListEffectHandler()
        mockTasksDataSource = MockTasksDataSource()
        mockEventConsumer = MockEventConsumer()
        subject = TasksListViewModel(effectHandler: effectHandler,
                                    dataSource: mockTasksDataSource,
                                    eventConsumer: mockEventConsumer.mockConsumer)
    }

    override func tearDown() {
        subject = nil
        effectHandler = nil
        mockTasksDataSource = nil
        mockEventConsumer = nil
        super.tearDown()
    }

    // MARK: - Tests

    func test_viewWillAppear_sendsRefreshRequestedEvent() {
        subject.viewWillAppear()
        XCTAssertEqual(mockEventConsumer.eventSpy, .refreshRequested)
    }

    func test_didPressAddTaskButton_sendsRefreshRequestedEvent() {
        subject.didPressAddTaskButton()
        XCTAssertEqual(mockEventConsumer.eventSpy, .newTaskClicked)
    }

    func test_didCompleteTaskCreation_sendsTaskCreated() {
        subject.didCompleteTaskCreation(title: "title", description: "description")
        XCTAssertEqual(mockEventConsumer.eventSpy, .taskCreated(title: "title", description: "description"))
    }
}


private final class MockTaskListEffectHandler: Connectable {

    func connect(_ consumer: @escaping Consumer<TasksList.Event>) -> Connection<TasksList.Effect> {
        return  Connection<TasksList.Effect>(
            acceptClosure: {_ in },
            disposeClosure: {}
        )
    }
}

private final class MockEventConsumer {

    var mockConsumerCallCount = 0
    var eventSpy: TasksList.Event? = nil
    func mockConsumer(_ event: TasksList.Event) -> Void {
        mockConsumerCallCount += 1
        eventSpy = event
    }

}

private final class MockTasksDataSource: TasksDataSource {
    func fetchTasks(_ completion: @escaping ([Task]) -> ()) {

    }

    func task(for id: String, completion: @escaping (Task?) -> ()) {

    }

    func save(task: Task) {

    }

    func deleteAllTasks() {

    }

    func deleteTask(for id: String) {
        
    }
}
