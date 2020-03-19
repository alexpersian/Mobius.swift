import UIKit

class TasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tasksListTableView: UITableView!

    private let dataSource = TaskRemoteDataSource()
    private var addTaskModal: UIAlertController?
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private var tasks: [Task] = [] {
        didSet { tasksListTableView.reloadData() }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupAddTaskModal()
        setupTableView()
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
        updateTaskList()
    }

    private func setupAddTaskModal() {
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
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            self.createNewTask(title: titleField?.text ?? "", description: descField?.text ?? "")
        }
        doneAction.isEnabled = false

        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: titleField, queue: .main) { _ in
            doneAction.isEnabled = titleField?.text?.isEmpty == false
        }

        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)

        addTaskModal = alertController
    }

    // MARK: - Updates

    private func createNewTask(title: String, description: String) {
        let newDetails = TaskDetails(title: title, description: description, isCompleted: false)
        let newTask = Task(details: newDetails)
        self.dataSource.save(task: newTask)
        self.updateTaskList()
    }

    private func updateTaskList() {
        activityIndicator.startAnimating()
        DispatchQueue.main.async {
            self.dataSource.fetchTasks { tasks in
                self.activityIndicator.stopAnimating()
                self.tasks = tasks
            }
        }
    }

    @IBAction func addTask(sender: UIBarButtonItem) {
        guard let modal = addTaskModal else {
            print("Error: Missing add task modal!")
            return
        }
        present(modal, animated: true, completion: nil)
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
