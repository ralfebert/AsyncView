import SwiftUI

public struct AsyncModelView<Success, Content: View>: View {
    @ObservedObject var model: AsyncModel<Success>
    public let content: (_ item: Success) -> Content

    public init(model: AsyncModel<Success>, @ViewBuilder content: @escaping (_ item: Success) -> Content) {
        self.model = model
        self.content = content
    }

    public var body: some View {
        AsyncResultView(
            result: model.result,
            reloadAction: { Task { await model.load(forceRefreshRequested: true) } },
            content: content
        )
        .onAppear {
            Task {
                await model.loadIfNeeded()
            }
        }
        .refreshable {
            await model.load(forceRefreshRequested: true)
        }
    }
}
