protocol TransitionExecutor {
    func prepare()
    func execute()
    func complete()
    func cancel()
}

// MARK: Factory methods

class TransitionExecutorFactory {

    static func transitionExecutor(withPrepareBlock prepareBlock: (() -> ())?, executeBlock: () -> (), completionBlock: ((cancelled: Bool) -> ())?) -> TransitionExecutor {
        return BlockTransitionExecutor.init(prepareBlock: prepareBlock, executeBlock: executeBlock, completionBlock: completionBlock)
    }

    static func transitionExecutor(withExecutors executors: [TransitionExecutor]) -> TransitionExecutor {
        return GroupTransitionExecutor.init(executors: executors)
    }

}

// MARK: Block based transition executor

private class BlockTransitionExecutor {
    let prepareBlock: (() -> ())?
    let executeBlock: () -> ()
    let completionBlock: ((cancelled: Bool) -> ())?

    init(prepareBlock: (() -> ())?, executeBlock: () -> (), completionBlock: ((cancelled: Bool) -> ())?) {
        self.prepareBlock = prepareBlock
        self.executeBlock = executeBlock
        self.completionBlock = completionBlock
    }
}

// MARK: Transition methods

extension BlockTransitionExecutor: TransitionExecutor {
    func prepare() {
        self.prepareBlock?()
    }

    func execute() {
        self.executeBlock()
    }

    func complete() {
        self.completionBlock?(cancelled: false)
    }

    func cancel() {
        self.completionBlock?(cancelled: true)
    }
}

// MARK: Grop based transition executor

private class GroupTransitionExecutor {

    let executors: [TransitionExecutor]
    init(executors: [TransitionExecutor]) {
        self.executors = executors
    }
}

// MARK: Transition methods

extension GroupTransitionExecutor: TransitionExecutor {
    func prepare() {
        executors.forEach { (executor) in
            executor.prepare()
        }
    }

    func execute() {
        executors.forEach { (executor) in
            executor.execute()
        }
    }

    func complete() {
        executors.forEach { (executor) in
            executor.complete()
        }
    }

    func cancel() {
        executors.forEach { (executor) in
            executor.cancel()
        }
    }
}
