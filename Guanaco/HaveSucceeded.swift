import Nimble
import Result

// MARK: Public

/**
  A Nimble matcher that succeeds when the actual value
  is a successful result.
*/
public func haveSucceeded<T, U>() -> NonNilMatcherFunc<Result<T, U>> {
  return NonNilMatcherFunc { actualExpression, failureMessage in
    failureMessage.postfixMessage = "have succeeded"
    if let result = actualExpression.evaluate() {
      return result.value != nil
    } else {
      return false
    }
  }
}

/**
  A Nimble matcher that succeeds when the actual value
  is a successful result, and the given matcher matches its value.

  :param: matcher The matcher to run against the successful value.
*/
public func haveSucceeded<T, U>(matcher: MatcherFunc<T>) -> NonNilMatcherFunc<Result<T, U>> {
  return haveSucceededMatcherFunc(MatcherClosure { matcher.matches($0, failureMessage: $1) })
}

/**
  A Nimble matcher that succeeds when the actual value
  is a successful result, and the given matcher matches its value.

  :param: matcher The matcher to run against the successful value.
*/
public func haveSucceeded<T, U>(matcher: FullMatcherFunc<T>) -> NonNilMatcherFunc<Result<T, U>> {
  return haveSucceededMatcherFunc(MatcherClosure { matcher.matches($0, failureMessage: $1) })
}

/**
  A Nimble matcher that succeeds when the actual value
  is a successful result, and the given matcher matches its value.

  :param: matcher The matcher to run against the successful value.
*/
public func haveSucceeded<T, U>(matcher: NonNilMatcherFunc<T>) -> NonNilMatcherFunc<Result<T, U>> {
  return haveSucceededMatcherFunc(MatcherClosure { matcher.matches($0, failureMessage: $1) })
}

// MARK: Private

private func haveSucceededMatcherFunc<T, U>(matcherClosure: MatcherClosure<T>) -> NonNilMatcherFunc<Result<T, U>> {
  return NonNilMatcherFunc { actualExpression, failureMessage in
    failureMessage.postfixMessage = "have succeeded"
    if let result = actualExpression.evaluate() {
      return result.analysis(
        ifSuccess: { value in
          let successfulExpression = Expression(expression: { value }, location: actualExpression.location)
          let matched = matcherClosure.closure(successfulExpression, failureMessage)
          failureMessage.to = "for"
          failureMessage.postfixMessage = "successful value to \(failureMessage.postfixMessage)"
          return matched!
        },
        ifFailure: { error in
            return false
        }
      )
    } else {
      return false
    }
  }
}
