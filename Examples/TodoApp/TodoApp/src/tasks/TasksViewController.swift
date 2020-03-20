import UIKit
import MobiusCore

class TasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tasksListTableView: UITableView!

    private let dataSource = TaskRemoteDataSource()
    private lazy var addTaskModal: UIAlertController = {
        createNewTaskAlertController()
    }()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private var mobiusController: MobiusController<TasksList.Model, TasksList.Event, TasksList.Effect>! //TODO: make it a let
    private var eventConsumer: Consumer<TasksList.Event>!

    private var tasks: [Task] = [] {
        didSet { tasksListTableView.reloadData() }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupTableView()
        setupMobiusController(with: tasks)

        updateTaskList() // TODO: This should be an event in Mobius (.viewLoaded / .initialLoad)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startLoop()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopLoop()
    }

    private func startLoop() {
        mobiusController.connectView(AnyConnectable<TasksList.Model, TasksList.Event>(self.connectViews))
        mobiusController.start()
    }

    private func stopLoop() {
        mobiusController?.stop()
        mobiusController?.disconnectView()
    }

    // MARK: - Setup

    private func setupMobiusController(with tasks: [Task]) {
        let effectHandler = TasksListEffectHandler()
        effectHandler.view = self
        mobiusController = MobiusControllerFactory(effectHandler: effectHandler,
                                                   initialModel: TasksList.Model(tasks: tasks, loading: false))
            .createController(with: update)
    }

    private func connectViews(consumer: @escaping Consumer<TasksList.Event>) -> Connection<TasksList.Model> {
        self.eventConsumer = consumer

        let accept: (TasksList.Model) -> Void = { model in
            print("accepting")
            // TODO: Move to view delegate pattern
            self.tasks = model.tasks // TODO: Remove this
        }
        let dispose = {
            print("disposing")
        }

        return Connection(acceptClosure: accept, disposeClosure: dispose)
    }

    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
    }

    private func setupTableView() {
        tasksListTableView.register(TasksListTableViewCell.self, forCellReuseIdentifier: "task-cell")
        tasksListTableView.dataSource = self
    }

    // MARK: - Updates

    private func updateTaskList() {
        activityIndicator.startAnimating()
        DispatchQueue.main.async {
            self.dataSource.fetchTasks { [weak self] tasks in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                self.eventConsumer(.tasksLoaded(tasks: tasks))
            }
        }
    }

    private func update(model: TasksList.Model, event: TasksList.Event) -> Next<TasksList.Model, TasksList.Effect> {
        switch event {
        case .newTaskClicked:
            return .dispatchEffects([.startTaskCreationFlow])
        case .tasksLoaded(let tasks):
            let newModel = TasksList.Model(tasks: tasks, loading: false)
            return .next(newModel)
        }
    }

    @IBAction func addTask(sender: UIBarButtonItem) {
        eventConsumer(.newTaskClicked)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "task-cell") as? TasksListTableViewCell else {
            fatalError("Failed to dequeue task cell")
        }
        cell.setupCell(with: tasks[indexPath.row])
        return cell
    }
}

protocol TaskViewing {
    func showAddTaskModal()
}

extension TasksViewController: TaskViewing {

    // MARK: - TaskViewing

    func showAddTaskModal() {
        DispatchQueue.main.async {
            self.present(self.addTaskModal, animated: true, completion: nil)
        }
    }

    // MARK: - Private

    private func createNewTaskAlertController() -> UIAlertController {
         let alertController = UIAlertController(title: "New Task", message: nil, preferredStyle: .alert)
         alertController.addTextField { textField in
             textField.placeholder = "Title"
         }
         alertController.addTextField { textField in
             textField.placeholder = "Description"
         }

         let titleField = alertController.textFields?[0]
         let descField = alertController.textFields?[1]

         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         let doneAction = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
             self?.createNewTask(title: titleField?.text ?? "", description: descField?.text ?? "")
         }
         doneAction.isEnabled = false

         NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: titleField, queue: .main) { _ in
             doneAction.isEnabled = titleField?.text?.isEmpty == false
         }

         alertController.addAction(cancelAction)
         alertController.addAction(doneAction)

         return alertController
     }

     private func createNewTask(title: String, description: String) {
         let newDetails = TaskDetails(title: title, description: description, isCompleted: false)
         let newTask = Task(details: newDetails)
         self.dataSource.save(task: newTask)
         self.updateTaskList()
     }
}
