import Nimble
import Result

// MARK: Public

/**
  A Nimble matcher that succeeds when the actual value
  is a failed result.
*/
public func haveFailed<T, U>() -> NonNilMatcherFunc<Result<T, U>> {
  return NonNilMatcherFunc { actualExpression, failureMessage in
    failureMessage.postfixMessage = "have failed"
    if let result = actualExpression.evaluate() {
      return result.error != nil
    } else {
      return false
    }
  }
}

/**
  A Nimble matcher that succeeds when the actual value
  is a failed result, and the given matcher matches its failure value.

  :param: matcher The matcher to run against the failure value.
*/
public func haveFailed<T, U>(matcher: MatcherFunc<U>) -> NonNilMatcherFunc<Result<T, U>> {
  return haveFailedMatcherFunc(MatcherClosure { matcher.matches($0, failureMessage: $1) })
}

/**
  A Nimble matcher that succeeds when the actual value
  is a failed result, and the given matcher matches its failure value.

  :param: matcher The matcher to run against the failure value.
*/
public func haveFailed<T, U>(matcher: FullMatcherFunc<U>) -> NonNilMatcherFunc<Result<T, U>> {
  return haveFailedMatcherFunc(MatcherClosure { matcher.matches($0, failureMessage: $1) })
}

/**
  A Nimble matcher that succeeds when the actual value
  is a failed result, and the given matcher matches its failure value.

  :param: matcher The matcher to run against the failure value.
*/
public func haveFailed<T, U>(matcher: NonNilMatcherFunc<U>) -> NonNilMatcherFunc<Result<T, U>> {
  return haveFailedMatcherFunc(MatcherClosure { matcher.matches($0, failureMessage: $1) })
}

// MARK: Private

private func haveFailedMatcherFunc<T, U>(matcherClosure: MatcherClosure<U>) -> NonNilMatcherFunc<Result<T, U>> {
  return NonNilMatcherFunc { actualExpression, failureMessage in
    failureMessage.postfixMessage = "have succeeded"
    if let result = actualExpression.evaluate() {
      return result.analysis(
        ifSuccess: { value in
          return false
        },
        ifFailure: { error in
          let failedExpression = Expression(expression: { error }, location: actualExpression.location)
          let matched = matcherClosure.closure(failedExpression, failureMessage)
          failureMessage.to = "for"
          failureMessage.postfixMessage = "failure value to \(failureMessage.postfixMessage)"
          return matched!
        }
      )
    } else {
      return false
    }
  }
}
