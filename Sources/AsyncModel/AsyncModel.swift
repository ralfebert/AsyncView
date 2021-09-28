import SwiftUI

@MainActor
open class AsyncModel<T>: ObservableObject {
    @Published public private(set) var result = AsyncResult<T>.ready

    let awaitBlock: () async throws -> T

    public init(awaitBlock: @escaping () async throws -> T) {
        self.awaitBlock = awaitBlock
    }

    public func load() async {
        if case .inProgress = self.result { return }
        self.result = .inProgress

        do {
            self.result = .success(try await self.awaitBlock())
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
