import Nimble

internal func assertionMessage(closure: @escaping () -> Void) -> String? {
  let recorder = AssertionRecorder()
  withAssertionHandler(recorder, closure: closure)
  return recorder.assertions.last?.message.stringValue
}
