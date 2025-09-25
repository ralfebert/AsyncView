import SwiftUI

public struct AsyncErrorView: View {
    let error: Error
    let reloadAction: () -> Void

    public init(error: any Error, reloadAction: @escaping () -> Void) {
        self.error = error
        self.reloadAction = reloadAction
    }

    public var body: some View {
        ContentUnavailableView(
            label: {
                Label(self.error.localizedDescription, systemImage: "exclamationmark.triangle.fill")
            },
            description: {},
            actions: {
                Button(
                    action: self.reloadAction,
                    label: {
                        Image(systemName: "arrow.clockwise")
                    }
                )
                .padding()
            }
        )
    }
}
