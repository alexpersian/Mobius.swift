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

    override func viewDidLoad() {
        super.viewDidLoad()
        tasksListTableView.register(TasksListTableViewCell.self, forCellReuseIdentifier: "task-cell")
        tasksListTableView.dataSource = self
    }

    @IBAction func addTask(sender: UIBarButtonItem) {
        print("adding task")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "task-cell")!
    }
}
