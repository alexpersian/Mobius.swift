import Foundation
import MobiusCore

// V -> VM -> EF
// EF -> VM -> V

// Input from View
protocol TasksListViewEventHandling {
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
    func didPressAddTaskButton()
    var view: TaskViewing? { get set }
}

// Input from Effect Handler
protocol TasksListViewModeling: AnyObject {
    func loadTasks()
    func save(task: Task)
    func showAddTaskModal()
}

final class TasksListViewModel: TasksListViewEventHandling {
    private let effectHandler: TasksListEffectHandler
    private var mobiusController: MobiusController<TasksList.Model, TasksList.Event, TasksList.Effect>?
    private var eventConsumer: Consumer<TasksList.Event>?
    private let dataSource: TasksDataSource

    weak var view: TaskViewing?

    // MARK: - Init

    init(effectHandler: TasksListEffectHandler = TasksListEffectHandler(),
         dataSource: TasksDataSource = TaskRemoteDataSource()) {
        self.effectHandler = effectHandler
        self.dataSource = dataSource
        effectHandler.viewModel = self
    }

    // MARK: - TasksListViewModeling

    func viewDidLoad() {
        setupMobiusController(with: TasksList.Model(tasks: [], loading: true))
    }

    func viewWillAppear() {
        startLoop()
        eventConsumer?(.refreshRequested)
    }

    func viewWillDisappear() {
        stopLoop()
    }

    func didPressAddTaskButton() {
        eventConsumer?(.newTaskClicked)
    }
    
    // MARK: - Private

    private func setupMobiusController(with model: TasksList.Model) {
        mobiusController = MobiusControllerFactory(effectHandler: effectHandler,
                                                   initialModel: model)
            .createController(with: update)
    }

    private func startLoop() {
        mobiusController?.connectView(AnyConnectable<TasksList.Model, TasksList.Event>(connectViews))
        mobiusController?.start()
    }

    private func stopLoop() {
        mobiusController?.stop()
        mobiusController?.disconnectView()
    }

    private func connectViews(consumer: @escaping Consumer<TasksList.Event>) -> Connection<TasksList.Model> {
        self.eventConsumer = consumer

        let accept: (TasksList.Model) -> Void = { [weak self] model in
            self?.view?.showSpinner(model.loading)
            self?.view?.show(tasksViewData: model.tasks.map {
                TaskViewData(title: $0.details.title, description: $0.details.description)
            })
        }

        return Connection(acceptClosure: accept, disposeClosure: {
            //nothing to dispose
        })
    }

    private func update(model: TasksList.Model, event: TasksList.Event) -> Next<TasksList.Model, TasksList.Effect> {
        switch event {
        case .refreshRequested:
            let newModel = TasksList.Model(tasks: model.tasks, loading: true)
            return .next(newModel, effects: [.loadTasks])
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
    func loadTasks() {
        dataSource.fetchTasks { [weak self] tasks in
            self?.eventConsumer?(.tasksLoaded(tasks: tasks))
        }
    }

    func showAddTaskModal() {
        view?.showAddTaskModal()
    }

    func save(task: Task) {
        dataSource.save(task: task)
    }
}
