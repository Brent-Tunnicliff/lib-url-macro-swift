# lib-url-macro-swift

Very simple package that contains the `#url` macro for creating a URL type from StaticString.

If the input is not a valid url then throws a compile error.

This way we can create base urls from StaticString without having to worry about optionals or runtime errors.

Example use:

```swift
let url: URL = #url("https://www.google.com")
```

Solution copied from [Swift by Sundell: Modern URL construction in Swift](https://www.swiftbysundell.com/articles/modern-url-construction-in-swift/)

## Source Stability

The versioning of this package follows [Semantic Versioning](https://semver.org/). Source breaking changes to public API require a new major version.

We'd like this package to quickly embrace Swift language and toolchain improvements, and expect the latest Swift toolchains to be used (i.e. latest public Xcode version). So we will include updating the Swift version of the package as a new minor version bump.

## Disclaimer

This project is open source and open to anyone to use as they see fit.
But I am building this with myself as the main target audience, so this will not be published anywhere.
