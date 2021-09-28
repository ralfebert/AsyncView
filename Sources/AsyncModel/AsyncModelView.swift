import SwiftUI

public struct AsyncModelView<T, Content: View>: View {
    @ObservedObject var model: AsyncModel<T>
    public let content: (_ item: T) -> Content

    public init(model: AsyncModel<T>, @ViewBuilder content: @escaping (_ item: T) -> Content) {
        self.model = model
        self.content = content
    }

    public var body: some View {
        AsyncResultView(
            result: model.result,
            reloadAction: { Task { await model.load() } },
            content: content
        )
        .task {
            await model.loadIfNeeded()
        }
        .refreshable {
            await model.load()
        }
    }
}
