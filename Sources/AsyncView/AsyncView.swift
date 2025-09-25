import SwiftUI

public struct AsyncView<Result, ResultView: View>: View {
    let operation: () async throws -> Result
    @ViewBuilder let content: (Result) -> ResultView
    @State var state: AsyncState = .ready

    public init(operation: @escaping () async throws -> Result, @ViewBuilder content: @escaping (Result) -> ResultView) {
        self.operation = operation
        self.content = content
        self.state = self.state
    }

    enum AsyncState {
        case ready
        case progress
        case loaded(Result)
        case error(Error)
    }

    public var body: some View {
        ZStack {
            switch self.state {
            case .ready:
                EmptyView()
            case .progress:
                ProgressView()
            case let .loaded(result):
                self.content(result)
            case let .error(error):
                AsyncErrorView(
                    error: error,
                    reloadAction: {
                        Task {
                            await self.reload()
                        }
                    }
                )
            }
        }
        .task {
            await self.reload()
        }
    }

    func reload() async {
        self.state = .progress
        do {
            self.state = try await .loaded(self.operation())
        } catch {
            self.state = .error(error)
        }
    }
}
