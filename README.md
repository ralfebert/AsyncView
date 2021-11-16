# AsyncView

AsyncView is a SwiftUI View for handling in-progress and error states when loading data asynchronously using async/await:

![Countries example](https://cdn.ralfebert.de/asyncview_states-3aba8003.png)

See [Structuring asynchronous loading operations in SwiftUI](https://www.ralfebert.com/ios-app-development/swiftui/asyncview/) for a tutorial and in-depth explanation of this package.

## Example projects

[Countries - Branch swiftui3-factbook-asyncview](https://github.com/ralfebert/Countries/tree/swiftui3-factbook-asyncview) shows a list of countries.

[MuseumGuide](https://github.com/ralfebert/MuseumGuide) loads a random artwork from the Met Museum API:

![MuseumGuide example](https://github.com/ralfebert/MuseumGuide/raw/main/docs/museum-example-xcode.jpg)


## Howto

### Endpoints

I recommend to define a type for every API and implement a method for every endpoint/remote call. For example, to load a [JSON list of countries](https://www.ralfebert.de/examples/v3/countries.json):

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

Using `AsyncModel` and `AsyncModelView`:

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

It is also possible to define the model as a separate class:

```swift
class CountriesModel: AsyncModel<[Country]> {
    override func asyncOperation() async throws -> [Country] {
        try await CountriesEndpoints().countries()
    }
}

struct CountriesView: View {
    @StateObject var countriesModel = CountriesModel()

    var body: some View {
        AsyncModelView(model: countriesModel) { countries in
            List(countries) { country in
                Text(country.name)
            }
        }
    }
}
```

For presenting data loaded from a URL endpoint without any additional logic, you can use `AsyncView`:

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
