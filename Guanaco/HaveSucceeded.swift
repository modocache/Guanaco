import Nimble
import LlamaKit

// MARK: Public

/**
  A Nimble matcher that succeeds when the actual value
  is a successful result.
*/
public func haveSucceeded<T>() -> MatcherFunc<Result<T, NSError>> {
  return MatcherFunc { actualExpression, failureMessage in
    failureMessage.postfixMessage = "have succeeded"
    if let result = actualExpression.evaluate() {
      return result.isSuccess
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
public func haveSucceeded<T>(matcher: MatcherFunc<T>) -> MatcherFunc<Result<T, NSError>> {
  return MatcherFunc { actualExpression, failureMessage in
    return matchesSuccessfulExpression(actualExpression, failureMessage) { successfulExpression, failureMessage in
      return matcher.matches(successfulExpression, failureMessage: failureMessage)
    }
  }
}

/**
  A Nimble matcher that succeeds when the actual value
  is a successful result, and the given matcher matches its value.

  :param: matcher The matcher to run against the successful value.
*/
public func haveSucceeded<T>(matcher: FullMatcherFunc<T>) -> FullMatcherFunc<Result<T, NSError>> {
  return FullMatcherFunc { actualExpression, failureMessage, _ in
    return matchesSuccessfulExpression(actualExpression, failureMessage) { successfulExpression, failureMessage in
      return matcher.matches(successfulExpression, failureMessage: failureMessage)
    }
  }
}

/**
  A Nimble matcher that succeeds when the actual value
  is a successful result, and the given matcher matches its value.

  :param: matcher The matcher to run against the successful value.
*/
public func haveSucceeded<T>(matcher: NonNilMatcherFunc<T>) -> NonNilMatcherFunc<Result<T, NSError>> {
  return NonNilMatcherFunc { actualExpression, failureMessage in
    return matchesSuccessfulExpression(actualExpression, failureMessage) { successfulExpression, failureMessage in
      return matcher.matches(successfulExpression, failureMessage: failureMessage)
    }
  }
}

// MARK: Private

private func matchesSuccessfulExpression<T, U>(actualExpression: Expression<Result<T, U>>, failureMessage: FailureMessage, closure: (Expression<T>, FailureMessage) -> Bool) -> Bool {
  if let result = actualExpression.evaluate() {
    switch result {
    case .Success(let box):
      let successfulExpression = Expression(expression: { box.unbox }, location: actualExpression.location)
      return closure(successfulExpression, failureMessage)
    case .Failure:
      return false
    }
  } else {
    return false
  }
}
