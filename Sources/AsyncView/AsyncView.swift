import SwiftUI

public struct AsyncView<Success, Content: View>: View {
    @StateObject var model: AsyncModel<Success>
    let content: (_ item: Success) -> Content

    public var body: some View {
        AsyncModelView(model: self.model, content: self.content)
    }
}

public extension AsyncView {
    init(operation: @escaping AsyncModel<Success>.AsyncOperation, @ViewBuilder content: @escaping (_ item: Success) -> Content) {
        self.init(model: AsyncModel(asyncOperation: operation), content: content)
    }
}
