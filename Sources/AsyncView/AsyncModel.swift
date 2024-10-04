import SwiftUI

open class AsyncModel<Success>: ObservableObject {
    @MainActor @Published public private(set) var result = AsyncResult<Success>.empty

    public typealias AsyncOperation = (Bool) async throws -> Success

    private var asyncOperationBlock: AsyncOperation = { _ in
        fatalError("Override asyncOperation or pass a asyncOperationBlock to use async model")
    }

    public init(asyncOperation: AsyncOperation? = nil) {
        if let asyncOperation = asyncOperation {
            self.asyncOperationBlock = asyncOperation
        }
    }

    open func asyncOperation(forceRefreshRequested: Bool) async throws -> Success {
        try await self.asyncOperationBlock(forceRefreshRequested)
    }

    @MainActor
    public func load(forceRefreshRequested: Bool) async {
        if case .inProgress = self.result { return }
        self.result = .inProgress

        do {
            self.result = .success(try await self.asyncOperation(forceRefreshRequested: forceRefreshRequested))
        } catch {
            self.result = .failure(error)
        }
    }

    @MainActor
    public func loadIfNeeded() async {
        switch self.result {
        case .empty, .failure:
            await self.load(forceRefreshRequested: false)
        case .inProgress, .success:
            break
        }
    }
}
