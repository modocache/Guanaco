import Nimble
import LlamaKit

/**
  A Nimble matcher that succeeds when the actual value
  is a failure result. This matcher can only be used with
  failures that encapsulate NSError types.

  :param: domain Optionally, the domain of the error. If specified, but
                 the actual failure error does not match this domain,
                 this matcher fails.
  :param: localizedDescription Optionally, the localized description of
                               the error. If specified, but the actual
                               failure error does not match this domain,
                               this matcher fails.
*/
public func haveFailed<T>(domain: String? = nil, localizedDescription: String? = nil) -> MatcherFunc<Result<T, NSError>> {
  return MatcherFunc { actualExpression, failureMessage in
    failureMessage.postfixMessage = "have failed"
    if let result = actualExpression.evaluate() {
      switch result {
      case .Success:
        return false
      case .Failure(let error):
        var allEqualityChecksAreTrue = true
        if let someDomain = domain {
          failureMessage.postfixMessage = "\(failureMessage.postfixMessage), with a domain of '\(someDomain)'"
          allEqualityChecksAreTrue = allEqualityChecksAreTrue && error.unbox.domain == someDomain
        }
        if let description = localizedDescription {
          failureMessage.postfixMessage = "\(failureMessage.postfixMessage), with the description '\(description)'"
          allEqualityChecksAreTrue = allEqualityChecksAreTrue && error.unbox.localizedDescription == description
        }
        return allEqualityChecksAreTrue
      }
    } else {
      return false
    }
  }
}
