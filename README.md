# AsyncView

AsyncView is a SwiftUI View that handles in-progress and error states when loading data asynchronously using async/await. It's like [AsyncImage](https://developer.apple.com/documentation/swiftui/asyncimage) but for data.

![Countries example](https://box-swiftui-garden.fra1.cdn.digitaloceanspaces.com/asyncview_loading_states.jpg)

## Howto

### Endpoints

I recommend to define a type for every API and implement a method for every endpoint/remote call. For example:

```swift
struct Artwork: Identifiable, Codable {
    public var id: String { objectID }
    var objectID: String
    var objectName: String
}

class MetMuseumEndpoints {
    let urlSession = URLSession.shared
    let jsonDecoder = JSONDecoder()
    
    static let shared = MetMuseumEndpoints()

    func artwork(id: Int) async throws -> [Artwork] {
        let url = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/objects/\(id)")!
        let (data, _) = try await urlSession.data(from: url)
        return try self.jsonDecoder.decode([Artwork].self, from: data)
    }
}
```

Have a look at [MetMuseumEndpoints](https://github.com/ralfebert/MetMuseumEndpoints/blob/main/Sources/MetMuseumEndpoints/MetMuseumEndpoints.swift#L303) for a more comprehensive example.

### Loading data for SwiftUI views asynchronously

For presenting data loaded from a URL endpoint directly in a SwiftUI View, you can use `AsyncView`:

```swift
import SwiftUI
import AsyncView

struct ArtworkView: View {
    var body: some View {
        AsyncView(
            operation: { try await MetMuseumEndpoints.shared.artwork(id: 45734) },
            content: { artwork in
                Text(artwork.objectName)
            }
        )
    }
}
```


## Example projects

[MuseumGuide](https://github.com/ralfebert/MuseumGuide) shows a gallery of artwork using the Met Museum API:

![MuseumGuide example](https://box-swiftui-garden.fra1.cdn.digitaloceanspaces.com/museumguide_example.jpg)

