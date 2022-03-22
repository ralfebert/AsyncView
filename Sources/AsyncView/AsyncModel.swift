import SwiftUI

open class AsyncModel<Success>: ObservableObject {
    @MainActor @Published public private(set) var result = AsyncResult<Success>.empty

    public typealias AsyncOperation = () async throws -> Success

    private var asyncOperationBlock: AsyncOperation = {
        fatalError("Override asyncOperation or pass a asyncOperationBlock to use async model")
    }

    public init(asyncOperation: AsyncOperation? = nil) {
        if let asyncOperation = asyncOperation {
            self.asyncOperationBlock = asyncOperation
        }
    }

    open func asyncOperation() async throws -> Success {
        try await self.asyncOperationBlock()
    }

    @MainActor
    public func load() async {
        if case .inProgress = self.result { return }
        self.result = .inProgress

        do {
            self.result = .success(try await self.asyncOperation())
        } catch {
            self.result = .failure(error)
        }
    }

    @MainActor
    public func loadIfNeeded() async {
        switch self.result {
        case .empty, .failure:
            await self.load()
        case .inProgress, .success:
            break
        }
    }
}
