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
    do {
      if let result = try actualExpression.evaluate(){
        return result.analysis(
          ifSuccess: { value in
            return true
          },
          ifFailure: { error in
            return false
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
  is a successful result, and the given matcher matches its value.

  :param: matcher The matcher to run against the successful value.
*/
public func haveSucceeded<T, U>(_ matcher: MatcherFunc<T>) -> NonNilMatcherFunc<Result<T, U>> {
  return haveSucceededMatcherFunc(MatcherClosure { try matcher.matches($0, failureMessage: $1) })
}

/**
  A Nimble matcher that succeeds when the actual value
  is a successful result, and the given matcher matches its value.

  :param: matcher The matcher to run against the successful value.
*/
public func haveSucceeded<T, U>(_ matcher: NonNilMatcherFunc<T>) -> NonNilMatcherFunc<Result<T, U>> {
  return haveSucceededMatcherFunc(MatcherClosure { try matcher.matches($0, failureMessage: $1) })
}

// MARK: Private

private func haveSucceededMatcherFunc<T, U>(_ matcherClosure: MatcherClosure<T>) -> NonNilMatcherFunc<Result<T, U>> {
  return NonNilMatcherFunc { actualExpression, failureMessage in
    failureMessage.postfixMessage = "have succeeded"
    do {
        if let result = try actualExpression.evaluate() {
        return result.analysis(
            ifSuccess: { value in
                do {
                  let successfulExpression = Expression(expression: { value }, location: actualExpression.location)
                  let matched = try matcherClosure.closure(successfulExpression, failureMessage)
                  failureMessage.to = "for"
                  failureMessage.postfixMessage = "successful value to \(failureMessage.postfixMessage)"
                  return matched!
                }
                catch{
                return false
                }
            },
            ifFailure: { error in
                return false
            }
        )
        }
        else {
            return false
        }
    } catch {
      return false
    }
  }
}
