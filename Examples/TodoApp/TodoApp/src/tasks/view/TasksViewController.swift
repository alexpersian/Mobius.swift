import UIKit

protocol TaskViewing: UIViewController {
    func showSpinner(_ show: Bool)
    func show(tasksViewData: [TaskViewData])
    func showAddTaskModal()
}

class TasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private weak var tasksListTableView: UITableView!
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    private var viewModel: TasksListViewEventHandling
    private var tasksViewData: [TaskViewData] = []
    private let taskCellIdentifier = "task-cell"

    required init?(coder: NSCoder) {
        viewModel = TasksListViewModel()
        super.init(coder: coder)
        viewModel.view = self
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        setupTableView()
        viewModel.viewDidLoad()
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
        tasksListTableView.register(TasksListTableViewCell.self, forCellReuseIdentifier: taskCellIdentifier)
        tasksListTableView.dataSource = self
    }

    // MARK: - Updates

    @IBAction func addTask(sender: UIBarButtonItem) {
        viewModel.didPressAddTaskButton()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksViewData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: taskCellIdentifier) as? TasksListTableViewCell else {
            fatalError("Failed to dequeue task cell")
        }
        cell.setupCell(with: tasksViewData[indexPath.row])
        return cell
    }
}

extension TasksViewController: TaskViewing {

    // MARK: - TaskViewing

    func showSpinner(_ show: Bool) {
        DispatchQueue.main.async {
            if show {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }

    func show(tasksViewData: [TaskViewData]) {
        DispatchQueue.main.async {
            self.tasksViewData = tasksViewData
            self.tasksListTableView.reloadData()
        }
    }

    func showAddTaskModal() {
        DispatchQueue.main.async {
            self.presentNewTaskModel()
        }
    }

    // MARK: - Private

    private func presentNewTaskModel() {
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
            self?.viewModel.didCompleteTaskCreation(title: titleField?.text ?? "", description: descField?.text ?? "")
        }

        doneAction.isEnabled = false

        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: titleField, queue: .main) { _ in
            doneAction.isEnabled = titleField?.text?.isEmpty == false
        }

        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)

        self.present(alertController, animated: true, completion: nil)
    }
}
