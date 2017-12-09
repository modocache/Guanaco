import Foundation
import Nimble

// MARK: Public

/**
  A Nimble matcher that succeeds when the NSError matches all
  of the specified conditions.

  :param: domain An assertion to be made on the error domain.
                 If nil, no assertion is made.
  :param: code An assertion to be made on the error code.
                 If nil, no assertion is made.
  :param: localizedDescription An assertion to be made on the error's
                               localized description. If nil, no assertion
                               is made.
*/
public func beAnError(domain: Predicate<String>? = nil, code: Predicate<Int>? = nil, localizedDescription: Predicate<String>? = nil) -> Predicate<NSError> {
  return beAnErrorMatcherFunc(
    domain: MatcherClosure { try domain?.matches($0, failureMessage: $1) },
    code: MatcherClosure { try code?.matches($0, failureMessage: $1) },
    localizedDescription: MatcherClosure { try localizedDescription?.matches($0, failureMessage: $1) }
  )
}

// MARK: Private

private func beAnErrorMatcherFunc(domain: MatcherClosure<String>? = nil, code: MatcherClosure<Int>? = nil, localizedDescription: MatcherClosure<String>? = nil) -> Predicate<NSError> {
  return Predicate{ (actual) throws -> PredicateResult in
    let message = ExpectationMessage.expectedActualValueTo("equal <\(actual)>")
    guard let error = try actual.evaluate() else {
      return PredicateResult(
        status: .fail,
        message: message.appendedBeNilHint()
      )
    }
    
    var allEqualityChecksAreTrue = true
    if let domainMatcherClosure = domain {
        let domainExpression = Expression(expression: { error.domain }, location: actual.location)
      if let match = try domainMatcherClosure.closure(domainExpression, FailureMessage.init(stringValue: message.expectedMessage)) {
            allEqualityChecksAreTrue = allEqualityChecksAreTrue && match
        }
    }
    if let codeMatcherClosure = code {
        let codeExpression = Expression(expression: { error.code }, location: actual.location)
        if let match = try codeMatcherClosure.closure(codeExpression, FailureMessage.init(stringValue: message.expectedMessage)) {
            allEqualityChecksAreTrue = allEqualityChecksAreTrue && match
        }
    }
    if let descriptionMatcherClosure = localizedDescription {
        let descriptionExpression = Expression(expression: { error.localizedDescription }, location: actual.location)
        if let match = try descriptionMatcherClosure.closure(descriptionExpression, FailureMessage.init(stringValue: message.expectedMessage)) {
            allEqualityChecksAreTrue = allEqualityChecksAreTrue && match
        }
    }
    return PredicateResult(bool: allEqualityChecksAreTrue, message: message)

    }
}
