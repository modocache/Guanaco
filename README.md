# Guanaco

[![Build Status](https://travis-ci.org/modocache/Guanaco.svg?branch=master)](https://travis-ci.org/modocache/Guanaco)

Nimble matchers for LlamaKit.

```swift
let result: Result<String, NSError> = success("llama")
expect(result).to(haveSucceeded())
expect(result).to(haveSucceeded(equal("llama")))
```

```swift
let error = NSError(domain: "guanaco", code: 10, userInfo: [NSLocalizedDescriptionKey: "lama guanicoe"])
let result: Result<String, NSError> = failure(error)
expect(result).to(haveFailed())
expect(result).to(haveFailed(beAnError(
  domain: equal("guanaco"),
  code: beGreaterThan(0),
  localizedDescription: match("guanicoe")
)))
```

## Why Use Guanaco: Testing Algebraic Data Types

Swift makes it easy to define ADTs, or "algebraic data types". The canonical
example of an algebraic data type is [LlamaKit's](https://github.com/LlamaKit/LlamaKit)
`Result<ValueType, ErrorType>` enum, which represents the result of some
operation. When the operation is successful, the `Result` provides a
value of type `ValueType`. When it is not, it provides a value of type
`ErrorType`:

```swift
switch result {
　case .Success(let value): /* ... */
　case .Failure(let error): /* ... */
}
```

Unfortunately, testing algebraic data types like `Result` can be a pain.
For example, if you had a result of type `Result<Int, NSError>`, and
wanted to test that it had a successful value of `10`, you'd have to
write:

```swift
switch result {
　case .Success(let value): XCTAssertEquals(value, 10)
　case .Failure(let error): XCTFail()
}
```

Tests should be clear, consise, and provide useful failure messages--in
other words, the code above isn't going to cut it! Instead, use Guanaco
to write:

```swift
expect(result).to(haveSucceeded(equal(10)))
```

## How to Install

### Git Submodules

First, add Guanaco as a Git submodule. From within your Git repository,
open the command line and run:

```
$ git submodule add \
    https://github.com/modocache/Guanaco.git \
    External/Guanaco # Specify any path you like here
```

Open the `.xcworkspace` for your project and add `Guanaco.xcodeproj` to
your workspace. Then, add `Guanaco-OSX.framework` or
`Guanaco-iOS.framework` to your test target's "Link Binary with
Libraries" build phase.

