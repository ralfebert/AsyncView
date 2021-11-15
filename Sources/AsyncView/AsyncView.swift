import SwiftUI

public struct AsyncView<T, Content: View>: View {
    @StateObject var model: AsyncModel<T>
    let content: (_ item: T) -> Content

    public var body: some View {
        AsyncModelView(model: self.model, content: self.content)
    }
}

public extension AsyncView {
    init(operation: @escaping AsyncModel<T>.AsyncOperation, @ViewBuilder content: @escaping (_ item: T) -> Content) {
        self.init(model: AsyncModel(asyncOperation: operation), content: content)
    }
}
