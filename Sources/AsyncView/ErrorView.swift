import SwiftUI

struct ErrorView: View {
    let error: Error
    let reloadAction: (() -> Void)?

    var body: some View {
        VStack(spacing: 10) {
            Text(error.localizedDescription)
            if let reloadAction = reloadAction {
                Button(
                    action: reloadAction,
                    label: {
                        Image(systemName: "arrow.clockwise")
                    }
                )
            }
        }
    }
}
