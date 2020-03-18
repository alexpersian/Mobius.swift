//
//  TasksViewController.swift
//  TodoApp
//
//  Created by Alexander Persian on 3/17/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tasksListTableView: UITableView!

    private let remoteDataSource = TaskRemoteDataSource()

    private var tasks: [Task] = [] {
        didSet { tasksListTableView.reloadData() }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tasksListTableView.register(TasksListTableViewCell.self, forCellReuseIdentifier: "task-cell")
        tasksListTableView.dataSource = self
        updateTaskList()
    }

    private func updateTaskList() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.remoteDataSource.fetchTasks { tasks in
                self.tasks = tasks
            }
        }
    }

    @IBAction func addTask(sender: UIBarButtonItem) {
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
            let newDetails = TaskDetails(title: titleField?.text ?? "", description: descField?.text ?? "", isCompleted: false)
            let newTask = Task(id: UUID().uuidString, details: newDetails)
            self.remoteDataSource.save(task: newTask)
            self.updateTaskList()
        }
        doneAction.isEnabled = false

        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: titleField, queue: .main) { _ in
            doneAction.isEnabled = titleField?.text?.isEmpty == false
        }

        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        present(alertController, animated: true, completion: nil)
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
