import SwiftUI

public struct AsyncResultView<Success, Content: View>: View {
    public let result: AsyncResult<Success>
    public let content: (_ item: Success) -> Content
    public let reloadAction: (() -> Void)?

    public init(result: AsyncResult<Success>, reloadAction: (() -> Void)? = nil, @ViewBuilder content: @escaping (_ item: Success) -> Content) {
        self.result = result
        self.content = content
        self.reloadAction = reloadAction
    }

    public var body: some View {
        switch result {
        case .empty:
            EmptyView()
        case .inProgress:
            ProgressView()
        case let .success(value):
            content(value)
        case let .failure(error):
            ErrorView(error: error, reloadAction: reloadAction)
        }
    }
}
