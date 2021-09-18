import SwiftUI

@MainActor
open class AsyncModel<T>: ObservableObject {
    @Published public private(set) var result = AsyncResult<T>()

    public init() {}

    open func load() async throws -> T {
        fatalError("AsyncModel#load needs to be overriden")
    }

    public func reload() async {
        if self.result.inProgress { return }
        self.result.startProgress()

        do {
            self.result.finish(value: try await self.load())
        } catch {
            self.result.finish(error: error)
        }
    }
}
