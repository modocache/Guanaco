import Nimble

internal struct MatcherClosure<T> {
  let closure: (Expression<T>, FailureMessage) throws -> Bool?

  init(closure: @escaping (Expression<T>, FailureMessage) throws -> Bool?) {
    self.closure = closure
  }
}
