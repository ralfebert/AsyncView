# AsyncView

A starting point for an abstraction for SwiftUI views that load data asynchronously: Handle in-progress and error states in a generic way.

## Howto

### Endpoints

Define a type for all endpoints and implement a method for every remote call. For example:

```swift
struct Country: Identifiable, Codable {
    var id: String
    var name: String
}

struct CountriesEndpoints {
    let urlSession = URLSession.shared
    let jsonDecoder = JSONDecoder()

    func countries() async throws -> [Country] {
        let url = URL(string: "https://www.ralfebert.de/examples/v3/countries.json")!
        let (data, _) = try await urlSession.data(from: url)
        return try self.jsonDecoder.decode([Country].self, from: data)
    }
}
```

Have a look at [MetMuseumEndpoints](https://github.com/ralfebert/MetMuseumEndpoints) for a more realistic API.

### Calling Endpoints

Explicit model + `AsyncModelView`:

```swift
import SwiftUI
import AsyncView

struct CountriesView: View {
    @StateObject var countriesModel = AsyncModel { try await CountriesEndpoints().countries() }

    var body: some View {
        AsyncModelView(model: countriesModel) { countries in
            List(countries) { country in
                Text(country.name)
            }
        }
    }
}
```

Short version with `AsyncView`:

```swift
import SwiftUI
import AsyncView

struct CountriesView: View {
    var body: some View {
        AsyncView(
            operation: { try await CountriesEndpoints().countries() },
            content: { countries in
                List(countries) { country in
                    Text(country.name)
                }
            }
        )
    }
}
```

Example project:

* Simple list of countries: [Countries - Branch swiftui3-factbook-asyncview](https://github.com/ralfebert/Countries/tree/swiftui3-factbook-asyncview)
* Showing a random artwork from the Met Museum API: [MuseumGuide](https://github.com/ralfebert/MuseumGuide)
 
