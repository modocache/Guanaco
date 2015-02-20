# Guanaco

[![Build Status](https://travis-ci.org/modocache/Guanaco.svg?branch=master)](https://travis-ci.org/modocache/Guanaco)

Nimble matchers for LlamaKit.

```swift
let result = success("Huzzah!")
expect(result).to(haveSucceeded())
expect(result).to(haveSucceeded(equal("Huzzah!")))

let numbers = success([1, 2, 3])
expect(numbers).to(haveSucceeded(contain(2)))
```

```swift
let error = NSError(
  domain: "What happen",
  code: 10,
  userInfo: [NSLocalizedDescriptionKey: "Uh-oh!"]
)
let result: Result<String, NSError> = failure(error)
expect(result).to(haveFailed())
expect(result).to(haveFailed(beAnError(
  domain: equal("What happen"),
  code: beGreaterThan(0),
  localizedDescription: match("!")
)))
```

