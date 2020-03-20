import UIKit

protocol TaskViewing: UIViewController {
    func showAddTaskModal()
    func showSpinner(_ show: Bool)
    func show(tasksViewData: [TaskViewData])
}

class TasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private weak var tasksListTableView: UITableView!
    private let viewModel: TasksListViewEventHandling

    private lazy var addTaskModal: UIAlertController = {
        createNewTaskAlertController()
    }()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private var tasksViewData: [TaskViewData] = []

    required init?(coder: NSCoder) {
        viewModel = TasksListViewModel()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupTableView()
        viewModel.viewDidLoad()
        updateTaskList() // TODO: This should be an event in Mobius (.viewLoaded / .initialLoad)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }

    // MARK: - Setup

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

//    private func updateTaskList() {
//        activityIndicator.startAnimating()
//        DispatchQueue.main.async {
//            self.dataSource.fetchTasks { [weak self] tasks in
//                guard let self = self else { return }
//                self.activityIndicator.stopAnimating()
//            }
//        }
//    }

    @IBAction func addTask(sender: UIBarButtonItem) {
        viewModel.didPressAddTaskButton()
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

extension TasksViewController: TaskViewing {

    // MARK: - TaskViewing

    func showAddTaskModal() {
        DispatchQueue.main.async {
            self.present(self.addTaskModal, animated: true, completion: nil)
        }
    }

    func show(tasksViewData: [TaskViewData]) {
        self.tasksViewData = tasksViewData
        tasksListTableView.reloadData()
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
        let title = titleField?.text ?? ""
        let description = alertController.textFields?[1].text ?? ""

         let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
         let doneAction = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            self?.eventConsumer(.taskCreated(title: title, description: description))
         }
         doneAction.isEnabled = false

         NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: titleField, queue: .main) { _ in
             doneAction.isEnabled = title.isEmpty == false
         }

         alertController.addAction(cancelAction)
         alertController.addAction(doneAction)

         return alertController
     }

     private func createNewTask(title: String, description: String) {
         self.dataSource.save(task: newTask)
         self.updateTaskList()
     }
}
