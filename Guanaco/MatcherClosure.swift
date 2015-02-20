import Nimble

internal struct MatcherClosure<T> {
  let closure: (Expression<T>, FailureMessage) -> Bool?

  init(closure: (Expression<T>, FailureMessage) -> Bool?) {
    self.closure = closure
  }
}
