import UIKit

class TasksListTableViewCell: UITableViewCell {

    override var reuseIdentifier: String? {
        return "task-cell"
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("Initializer not implemented.")
    }

    func setupCell(with task: Task) {
        self.selectionStyle = .none
        self.textLabel?.text = task.details.title
        self.detailTextLabel?.text = task.details.description
    }
}
