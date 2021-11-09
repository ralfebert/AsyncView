import SwiftUI

@MainActor
open class AsyncModel<T>: ObservableObject {
    @Published public private(set) var result = AsyncResult<T>.ready

    public init() {}

    open func asyncOperation() async throws -> T {
        fatalError("Override asyncOperation and perform your async loading task")
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
