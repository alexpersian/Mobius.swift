import MobiusCore
import MobiusExtras

final class MobiusControllerFactory {

    // TODO: Maybe make a singleton?

//    private let loopBuilder: Mobius.Builder<CounterModel, CounterEvent, CounterEffect>!
//    private let counterEffectHandler: CounterEffectHandler
//    private let loopController: MobiusController<CounterModel, CounterEvent, CounterEffect>
//    private var eventConsumer: Consumer<CounterEvent>?
//    weak var viewDelegate: ConfettiCounterViewController? {
//        didSet {
//            counterEffectHandler.viewDelegate = viewDelegate
//        }
//    }
    // MARK: - Init
//    init(counterEffectHandler: CounterEffectHandler = CounterEffectHandler()) {
//        self.counterEffectHandler = counterEffectHandler
//        self.loopBuilder = Mobius
//            .loop(update: CounterUpdateLoop().update,
//                  effectHandler: counterEffectHandler)
//            .withLogger(SimpleLogger<CounterModel, CounterEvent, CounterEffect>(tag: "confetti_counter"))
//        self.loopController = loopBuilder.makeController(from: 0)
//        self.loopController.connectView(AnyConnectable<CounterModel, CounterEvent>(connectViews))
//    }


    func createController(effectHandler: EffectHandler(),
                          eventSource: EventSource(),
                          defaultModel: TasksListModel) -> MobiusController<TasksListModel, TasksListEvent, TasksListEffect> {

        let builder: Mobius.Builder<TasksListModel, TasksListEvent, TasksListEffect> = Mobius
            .loop(update: { (m, e) -> Next<TasksListModel, TasksListEffect> in
                //
            }, effectHandler: effectHandler)
            .withLogger(SimpleLogger<TasksListModel, TasksListEvent, TasksListEffect>(tag: "tasks_list"))

    }
//
//    private func createLoop(eventSource: EventSource<TasksListEvent>,
//                            effectHandler: ConsumerTransformer<TasksListEffect, TasksListEvent>) -> Mobius.Builder<TasksListModel, TasksListEvent, TasksListEffect> {
//
//    }
}
