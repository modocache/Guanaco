import Quick
import Nimble
import LlamaKit
import Guanaco

class HaveFailedSpec: QuickSpec {
  override func spec() {
    describe("haveFailed") {
      context("when the actual value is a success") {
        it("fails") {
          let message = assertionMessage {
            expect(success("linkedin for drunk texts")).to(haveFailed())
          }
          expect(message).to(match("expected to have failed, got"))
        }
      }
    }
  }
}
