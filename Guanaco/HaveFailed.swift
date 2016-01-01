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
    do {
      if let result = try actualExpression.evaluate(){
        return result.analysis(
          ifSuccess: { value in
            return false
          },
          ifFailure: { error in
            return true
          }
        )
      } else {
        return false
      }
    } catch {
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
  return haveFailedMatcherFunc(MatcherClosure { try matcher.matches($0, failureMessage: $1) })
}

/**
  A Nimble matcher that succeeds when the actual value
  is a failed result, and the given matcher matches its failure value.

  :param: matcher The matcher to run against the failure value.
*/
public func haveFailed<T, U>(matcher: FullMatcherFunc<U>) -> NonNilMatcherFunc<Result<T, U>> {
  return haveFailedMatcherFunc(MatcherClosure { try matcher.matches($0, failureMessage: $1) })
}

/**
  A Nimble matcher that succeeds when the actual value
  is a failed result, and the given matcher matches its failure value.

  :param: matcher The matcher to run against the failure value.
*/
public func haveFailed<T, U>(matcher: NonNilMatcherFunc<U>) -> NonNilMatcherFunc<Result<T, U>> {
  return haveFailedMatcherFunc(MatcherClosure { try matcher.matches($0, failureMessage: $1) })
}

// MARK: Private

private func haveFailedMatcherFunc<T, U>(matcherClosure: MatcherClosure<U>) -> NonNilMatcherFunc<Result<T, U>> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "have succeeded"
        
        let errorClosure: (error: U) -> Bool = { error in
            do {
                let failedExpression = Expression(expression: { error }, location: actualExpression.location)
                let matched = try matcherClosure.closure(failedExpression, failureMessage)
                failureMessage.to = "for"
                failureMessage.postfixMessage = "failure value to \(failureMessage.postfixMessage)"
                return matched!
            }
            catch {
                return false
            }
        }
        
        do {
            if let result = try actualExpression.evaluate(){
                return result.analysis(
                    ifSuccess: { value in
                        return false
                    },
                    ifFailure: errorClosure
                )
            }
            return false
        }
        catch let error as U {
            return errorClosure(error: error)
        }
    }
}
