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
public func beAnError(domain: NonNilMatcherFunc<String>? = nil, code: NonNilMatcherFunc<Int>? = nil, localizedDescription: NonNilMatcherFunc<String>? = nil) -> NonNilMatcherFunc<NSError> {
  return beAnErrorMatcherFunc(
    domain: MatcherClosure { try domain?.matches($0, failureMessage: $1) },
    code: MatcherClosure { try code?.matches($0, failureMessage: $1) },
    localizedDescription: MatcherClosure { try localizedDescription?.matches($0, failureMessage: $1) }
  )
}

// MARK: Private

private func beAnErrorMatcherFunc(domain: MatcherClosure<String>? = nil, code: MatcherClosure<Int>? = nil, localizedDescription: MatcherClosure<String>? = nil) -> NonNilMatcherFunc<NSError> {
  return NonNilMatcherFunc { actualExpression, failureMessage in
    
    guard let error = try actualExpression.evaluate() else {
        return false
    }
    
    var allEqualityChecksAreTrue = true
    if let domainMatcherClosure = domain {
        let domainExpression = Expression(expression: { error.domain }, location: actualExpression.location)
        if let match = try domainMatcherClosure.closure(domainExpression, failureMessage) {
            allEqualityChecksAreTrue = allEqualityChecksAreTrue && match
        }
    }
    if let codeMatcherClosure = code {
        let codeExpression = Expression(expression: { error.code }, location: actualExpression.location)
        if let match = try codeMatcherClosure.closure(codeExpression, failureMessage) {
            allEqualityChecksAreTrue = allEqualityChecksAreTrue && match
        }
    }
    if let descriptionMatcherClosure = localizedDescription {
        let descriptionExpression = Expression(expression: { error.localizedDescription }, location: actualExpression.location)
        if let match = try descriptionMatcherClosure.closure(descriptionExpression, failureMessage) {
            allEqualityChecksAreTrue = allEqualityChecksAreTrue && match
        }
    }
    return allEqualityChecksAreTrue

    }
}
