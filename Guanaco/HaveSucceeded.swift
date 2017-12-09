import Nimble
import Result

// MARK: Public

/**
  A Nimble matcher that succeeds when the actual value
  is a successful result.
*/
public func haveSucceeded<T, U>() -> Predicate<Result<T, U>> {
  return Predicate { actualExpression in
    let message = ExpectationMessage.expectedActualValueTo("have succeeded")
    do {
      if let result = try actualExpression.evaluate(){
        return result.analysis(
          ifSuccess: { value in
            return PredicateResult(
              status: .matches,
              message: message
            )
          },
          ifFailure: { error in
            return PredicateResult(
              status: .fail,
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
  is a successful result, and the given matcher matches its value.

  :param: matcher The matcher to run against the successful value.
*/
public func haveSucceeded<T, U>(_ matcher: Predicate<T>) -> Predicate<Result<T, U>> {
  return haveSucceededMatcherFunc(MatcherClosure { try matcher.matches($0, failureMessage: $1) })
}

// MARK: Private

private func haveSucceededMatcherFunc<T, U>(_ matcherClosure: MatcherClosure<T>) -> Predicate<Result<T, U>> {
  return Predicate { actualExpression in
    let message = ExpectationMessage.expectedActualValueTo("have succeeded")
    do {
        if let result = try actualExpression.evaluate() {
        return result.analysis(
            ifSuccess: { value in
                do {
                  let successfulExpression = Expression(expression: { value }, location: actualExpression.location)
                  let matched = try matcherClosure.closure(successfulExpression, FailureMessage.init(stringValue: message.expectedMessage))
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
                }
                catch{
                  return PredicateResult(
                    status: .fail,
                    message: message
                  )
                }
            },
            ifFailure: { error in
              return PredicateResult(
                status: .fail,
                message: message
              )
            }
        )
        }
        else {
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
}
