import SwiftUI

@MainActor
open class AsyncModel<T>: ObservableObject {
    @Published public private(set) var result = AsyncResult<T>.ready

    public typealias AsyncOperation = () async throws -> T

    private var asyncOperationBlock: AsyncOperation = {
        fatalError("Override asyncOperation or pass a asyncOperationBlock to use async model")
    }

    public init(asyncOperation: AsyncOperation? = nil) {
        if let asyncOperation = asyncOperation {
            self.asyncOperationBlock = asyncOperation
        }
    }

    open func asyncOperation() async throws -> T {
        try await self.asyncOperationBlock()
    }

    public func load() async {
        if case .inProgress = self.result { return }
        self.result = .inProgress

        do {
            self.result = .success(try await self.asyncOperation())
        } catch {
            self.result = .failure(error)
        }
    }

    public func loadIfNeeded() async {
        switch self.result {
        case .ready, .failure:
            await self.load()
        case .inProgress, .success:
            break
        }
    }
}
