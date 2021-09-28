import Foundation

/**
 AsyncResult represents the state of an asynchronous task and its result.

 It is similar to Swift's Result type but can also represent a 'no value' and 'work in progress' state.

 This type was created to enable a generic SwiftUI View that handles the 'no value' / 'work in progress' / 'error' states which are often very similar for many different Views. See ``AsyncResultView`` for a simple example implementation for such a view.
 */
@frozen public enum AsyncResult<Success> {
    case ready
    case inProgress
    case success(Success)
    case failure(Error)
}
