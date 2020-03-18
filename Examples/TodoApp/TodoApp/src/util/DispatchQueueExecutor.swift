import Foundation

/// Executes code on a given queue
/// If running in unit tests, executes the code synchronously, without applying the delay

final class DispatchQueueExecutor {
    private let queue: DispatchQueue
    private let isUnitTest: Bool

    init(queue: DispatchQueue = DispatchQueue(label: "concurrentQueue", attributes: .concurrent),
        isUnitTest: Bool = false) {
        self.queue = queue
        self.isUnitTest = isUnitTest
    }

    func syncAfter(dispatchTime: DispatchTime = DispatchTime.now(),
                   _ block: @escaping () -> Void) {
        if isUnitTest {
            // We want unit tests to run synchronously, without a delay
            block()
        } else {
            queue.asyncAfter(deadline: dispatchTime, execute: block)
        }
    }

    func asyncAfter(dispatchTime: DispatchTime,
                    flags: DispatchWorkItemFlags,
                    _ block: @escaping () -> Void) {
        if isUnitTest {
            // We want unit tests to run synchronously, without a delay
            syncAfter(block)
        } else {
            queue.asyncAfter(deadline: dispatchTime, flags: flags, execute: block)
        }
    }
}
