import MobiusCore
import MobiusExtras

final class MobiusControllerFactory {

    private let effectHandler: TasksListEffectHandler
    private let initialModel: TasksList.Model
    private let loggerTag = "tasks_list"

    // MARK: - Init

    init(effectHandler: TasksListEffectHandler = TasksListEffectHandler(),
         initialModel: TasksList.Model) {
        self.effectHandler = effectHandler
        self.initialModel = initialModel
    }

    // TODO: Reevaluate the signature here. Right now we are required to pass in the Update function.
    func createController(with update: @escaping (TasksList.Model, TasksList.Event) -> Next<TasksList.Model, TasksList.Effect>) -> MobiusController<TasksList.Model, TasksList.Event, TasksList.Effect> {
        let builder: Mobius.Builder<TasksList.Model, TasksList.Event, TasksList.Effect> = Mobius
            .loop(update: update, effectHandler: effectHandler)
            .withLogger(SimpleLogger<TasksList.Model, TasksList.Event, TasksList.Effect>(tag: loggerTag))
        return builder.makeController(from: initialModel)
    }
}
