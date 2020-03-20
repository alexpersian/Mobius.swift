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

    func setupCell(with taskViewData: TaskViewData) {
        self.selectionStyle = .none
        self.textLabel?.text = taskViewData.title
        self.detailTextLabel?.text = taskViewData.description
    }
}
