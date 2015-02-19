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
let result: Result<String, NSError> = failure("Boo-hoo!")
expect(result).to(haveFailed())
expect(result).to(haveFailed(localizedDescription: "Boo-hoo!"))
```

