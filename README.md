# foundation-helpers

Contains various helpers for Foundation (& FoundationEssential) types.

## URLHelpers

Convenient helpers for the URL type.   

### #url macro

Freestanding macro that checks if the input string literal is a valid URL.

If the input is valid, then returns the URL type removing the need for handling optional.

If the input is not a valid URL, then a compile error is thrown.

Example use:

```swift
let url: URL = #url("https://www.tunnicliff.dev")
```

Can be useful as a base url that gets referenced in other values:

```swift
let baseUrl: URL = #url("https://www.tunnicliff.dev")
let deviceEndpoint: URL = baseUrl.appending(path: "device")
let userEndpoint: URL = baseUrl.appending(path: "user")
```

## Source Stability

The versioning of this package follows [Semantic Versioning](https://semver.org/). Source breaking changes to public API require a new major version.

We'd like this package to quickly embrace Swift language and toolchain improvements, and expect the latest Swift toolchains to be used (i.e. latest public Xcode version). So we will include updating the Swift version of the package as a new minor version bump.

## Disclaimer

I only ever pretend to know what I am doing. If you find something wrong please raise an issue to let me know.

This project is open source and open to anyone to use as they see fit, but I am building this with myself as the main target audience.
