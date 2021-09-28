import SwiftUI

public struct AsyncResultView<T, Content: View>: View {
    public let result: AsyncResult<T>
    public let content: (_ item: T) -> Content

    public init(result: AsyncResult<T>, @ViewBuilder content: @escaping (_ item: T) -> Content) {
        self.result = result
        self.content = content
    }

    public var body: some View {
        switch result {
        case .ready:
            EmptyView()
        case .inProgress:
            ProgressView()
        case let .success(value):
            content(value)
        case let .failure(error):
            ErrorView(error: error)
        }
    }
}

public struct ErrorView: View {
    public let error: Error

    public var body: some View {
        VStack {
            Image(systemName: "exclamationmark.icloud")
            Text(error.localizedDescription)
        }
    }
}
