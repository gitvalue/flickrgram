import Foundation

/// Operation that performs synchronous task
public final class SyncOperation<T>: Operation {
    public override var isExecuting: Bool { isRunning }
    public override var isFinished: Bool { isDone }
    public override var isAsynchronous: Bool { true }

    private var isRunning = false
    private var isDone = false
    
    private let task: () -> (T)
    private let completion: (T) -> ()
    
    /// Designated initializer
    /// - Parameters:
    ///   - task: Synchronous task
    ///   - completion: Task completion handler
    public init(
        task: @escaping () -> (T),
        completion: @escaping (T) -> ()
    ) {
        self.task = task
        self.completion = completion
    }

    public override func start() {
        guard !isCancelled else { finish() ; return }

        willChangeValue(for: \.isExecuting)
        isRunning = true
        didChangeValue(for: \.isExecuting)
        
        perform()
    }

    public override func cancel() {
        super.cancel()
        finish()
    }

    private func perform() {
        let result = task()
        
        if !isCancelled {
            completion(result)
        }
        
        finish()
    }

    private func finish() {
        willChangeValue(for: \.isExecuting)
        isRunning = false
        didChangeValue(for: \.isExecuting)

        willChangeValue(for: \.isFinished)
        isDone = true
        didChangeValue(for: \.isFinished)
    }
}
