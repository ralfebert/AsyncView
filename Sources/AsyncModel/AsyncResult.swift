import Foundation

/**
 AsyncResult represents the state of an asynchronous task and its result.

 It is similar to Swift's Result type but can also represent a 'no value' and 'work in progress' state.

 This type was created to enable a generic SwiftUI View that handles the 'no value' / 'work in progress' / 'error' states which are often very similar for many different Views. See ``AsyncResultView`` for a simple example implementation for such a view.

 Note: Why is this not an enum? -> When you already have a success result and then start a task to refresh, you might want to keep the current value until the task is completed. This cannot be represented with an enum.
 */
@frozen public struct AsyncResult<Success> {
    public private(set) var value: Result<Success, Error>?
    public private(set) var inProgress: Bool = false

    mutating func startProgress() {
        // keep a previously loaded value, clear an error
        if case .failure = self.value {
            self.value = nil
        }
        self.inProgress = true
    }

    mutating func finish(value: Success) {
        self.value = .success(value)
        self.inProgress = false
    }

    mutating func finish(error: Error) {
        self.value = .failure(error)
        self.inProgress = false
    }

    var currentValue: Success? {
        switch self.value {
        case let .success(value):
            return value
        default:
            return nil
        }
    }
}
