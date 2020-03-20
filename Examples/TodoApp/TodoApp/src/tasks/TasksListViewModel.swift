import Foundation
import MobiusCore

// Input
protocol TasksListViewEventHandling {
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func didPressAddTaskButton()
}

// Output
protocol TasksListViewModeling: AnyObject {
    func show(tasks: [Task])
}

final class TasksListViewModel: TasksListViewEventHandling {

    private let effectHandler: TasksListEffectHandler
    private var mobiusController: MobiusController<TasksList.Model, TasksList.Event, TasksList.Effect>! //TODO: make it a let
    private var eventConsumer: Consumer<TasksList.Event>!

    weak var view: TaskViewing?

    // MARK: - Init

    init(effectHandler: TasksListEffectHandler = TasksListEffectHandler()) {
        self.effectHandler = effectHandler
        effectHandler.viewModel = self
    }

    // MARK: - TasksListViewModeling

    func viewDidLoad() {
        setupMobiusController(with: TasksList.Model(tasks: [], loading: true))
        eventConsumer(.refreshRequested)
    }

    func viewWillAppear() {
        startLoop()
    }

    func viewWillDisappear() {
        stopLoop()
    }

    func didPressAddTaskButton() {
        eventConsumer(.newTaskClicked)
    }
    
    // MARK: - Private

    private func setupMobiusController(with model: TasksList.Model) {
        mobiusController = MobiusControllerFactory(effectHandler: effectHandler,
                                                   initialModel: model)
            .createController(with: update)
    }

    private func startLoop() {
        mobiusController.connectView(AnyConnectable<TasksList.Model, TasksList.Event>(connectViews))
        mobiusController.start()
    }

    private func stopLoop() {
        mobiusController?.stop()
        mobiusController?.disconnectView()
    }

    private func connectViews(consumer: @escaping Consumer<TasksList.Event>) -> Connection<TasksList.Model> {
        self.eventConsumer = consumer

        let accept: (TasksList.Model) -> Void = { model in
//            self.tasks = model.tasks // TODO: Remove this
        }

        return Connection(acceptClosure: accept, disposeClosure: {
            //nothing to dispose
        })
    }

    private func update(model: TasksList.Model, event: TasksList.Event) -> Next<TasksList.Model, TasksList.Effect> {
        switch event {
        case .refreshRequested:
            return .dispatchEffects([.loadTasks])
        case .tasksLoaded(let tasks):
            let newModel = TasksList.Model(tasks: tasks, loading: false)
            return .next(newModel)
        case .newTaskClicked:
            return .dispatchEffects([.startTaskCreationFlow])
        case .taskCreated(let title, let description):
            let newTask = Task(details: TaskDetails(title: title, description: description))
            let newModel = TasksList.Model(tasks: model.tasks + [newTask], loading: false)
            return .next(newModel, effects: [.saveTask(task: newTask)])
        }
    }
}

extension TasksListViewModel: TasksListViewModeling {
    func show(tasks: [Task]) {
        let tasksViewData = tasks.map {
            TaskViewData(title: $0.details.title, description: $0.details.description)
        }
        view?.show(tasksViewData: tasksViewData)
    }
}
