import MobiusCore
import MobiusExtras

final class MobiusControllerFactory {

    private let effectHandler: TasksListEffectHandler
    private let initialModel: TasksListModel
    private let loggerTag = "tasks_list"

    // MARK: - Init

    init(effectHandler: TasksListEffectHandler = TasksListEffectHandler(),
         initialModel: TasksListModel) {
        self.effectHandler = effectHandler
        self.initialModel = initialModel
    }

    func createController() -> MobiusController<TasksListModel, TasksListEvent, TasksListEffect> {
        let builder: Mobius.Builder<TasksListModel, TasksListEvent, TasksListEffect> = Mobius
            .loop(update: { (m, e) -> Next<TasksListModel, TasksListEffect> in
                // TODO: implement update function
                return .noChange
            }, effectHandler: effectHandler)
            .withLogger(SimpleLogger<TasksListModel, TasksListEvent, TasksListEffect>(tag: loggerTag))
        return builder.makeController(from: initialModel)
    }
}
