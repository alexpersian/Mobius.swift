//
//  TasksListTableViewCell.swift
//  TodoApp
//
//  Created by Alexander Persian on 3/18/20.
//  Copyright © 2020 Spotify. All rights reserved.
//

import UIKit

class TasksListTableViewCell: UITableViewCell {

    override var reuseIdentifier: String? {
        return "task-cell"
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("Initializer not implemented.")
    }

    private func setupCell() {
        self.selectionStyle = .none
        self.textLabel?.text = "Hello world!"
        self.detailTextLabel?.text = "This is a new task for displaying."
    }
}
