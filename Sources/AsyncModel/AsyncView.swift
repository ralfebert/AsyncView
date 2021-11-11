import SwiftUI

public struct AsyncView<T, Content: View>: View {
    @StateObject private var model: AsyncModel<T>
    public let content: (_ item: T) -> Content

    public init(operation: @escaping AsyncModel<T>.AsyncOperation, @ViewBuilder content: @escaping (_ item: T) -> Content) {
        self._model = StateObject(wrappedValue: AsyncModel(asyncOperation: operation))
        self.content = content
    }

    public var body: some View {
        AsyncModelView(model: self.model, content: self.content)
    }
}
