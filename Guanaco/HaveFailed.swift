import Nimble
import Result

// MARK: Public

/**
  A Nimble matcher that succeeds when the actual value
  is a failed result or an error is thrown of the same type that caused the failure
*/
public func haveFailed<T, U>() -> Predicate<Result<T, U>> {
  return Predicate { actualExpression in
    let message = ExpectationMessage.expectedActualValueTo("have failed")
    do {
      if let result = try actualExpression.evaluate(){
        return result.analysis(
          ifSuccess: { value in
            return PredicateResult(
              status: .fail,
              message: message
            )
          },
          ifFailure: { error in
            return PredicateResult(
              status: .matches,
              message: message
            )
          }
        )
      } else {
        return PredicateResult(
          status: .fail,
          message: message
        )
      }
    } catch let error where type(of: error) == U.self {
      return PredicateResult(
        status: .matches,
        message: message
      )
    } catch {
      return PredicateResult(
        status: .fail,
        message: message
      )
    }
  }
}

/**
  A Nimble matcher that succeeds when the actual value
  is a failed result, and the given matcher matches its failure value.

  :param: matcher The matcher to run against the failure value.
*/
public func haveFailed<T, U>(_ matcher: Predicate<U>) -> Predicate<Result<T, U>> {
  return haveFailedMatcherFunc(MatcherClosure { try matcher.matches($0, failureMessage: $1) })
}

// MARK: Private

private func haveFailedMatcherFunc<T, U>(_ matcherClosure: MatcherClosure<U>) -> Predicate<Result<T, U>> {
  return Predicate { actualExpression in
    let message = ExpectationMessage.expectedActualValueTo("expected for failure value to match")
    
    let errorClosure: (_ error: U) -> PredicateResult = { error in
        do {
          let failedExpression = Expression(expression: { error }, location: actualExpression.location)
          let matched = try matcherClosure.closure(failedExpression, FailureMessage.init(stringValue: message.expectedMessage))
          if matched == true {
            return PredicateResult(
              status: .matches,
              message: message
            )
          } else {
            return PredicateResult(
              status: .fail,
              message: message
            )
          }
        } catch {
          return PredicateResult(
            status: .fail,
            message: message
          )
      }
    }
    
    do {
      if let result = try actualExpression.evaluate(){
        return result.analysis(
          ifSuccess: { value in
            return PredicateResult(
              status: .fail,
              message: message
            )
          },
          ifFailure: errorClosure
        )
      }
      return PredicateResult(
        status: .fail,
        message: message
      )
    }
    catch let error as U {
      return errorClosure(error)
    }
  }
}
