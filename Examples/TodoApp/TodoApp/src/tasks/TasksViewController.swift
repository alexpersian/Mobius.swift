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
        print("adding task")
        let taskId = UUID().uuidString
        let newDetails = TaskDetails(title: "New Task", description: "This is a new task to add.", isCompleted: false)
        let newTask = Task(id: taskId, details: newDetails)
        remoteDataSource.save(task: newTask)
        updateTaskList()
    }

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
