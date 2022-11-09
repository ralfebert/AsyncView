import SwiftUI

struct ErrorView: View {
    let error: Error
    let reloadAction: (() -> Void)?
    @State private var showingPopover = false

    var body: some View {
        VStack(spacing: 10) {
            Button(error.localizedDescription) {
                showingPopover = true
            }
#if os(iOS)
            .buttonStyle(.borderedProminent)
#else
            .buttonStyle(.link)
#endif
            .popover(isPresented: $showingPopover) {
                Text(String(NSString(string: "\(error)")))
                    .font(.caption)
                    .padding()
            }
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
