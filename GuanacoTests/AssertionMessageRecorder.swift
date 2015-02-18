import Nimble

internal func assertionMessage(closure: () -> Void) -> String? {
  let recorder = AssertionRecorder()
  withAssertionHandler(recorder, closure)
  return last(recorder.assertions)?.message
}
