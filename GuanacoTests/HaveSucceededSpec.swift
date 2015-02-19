import Quick
import Nimble
import LlamaKit
import Guanaco

class HaveSucceededSpec: QuickSpec {
  override func spec() {
    describe("haveSucceeded") {
      context("when the actual value is a failure") {
        it("fails") {
          let message = assertionMessage {
            let actual: Result<String, NSError> = failure("snapchat for seniors")
            expect(actual).to(haveSucceeded())
          }
          expect(message).to(match("expected to have succeeded, got"))
        }
      }

      context("when the actual value is a successful result") {
        it("doesn't fail") {
          expect(success("tumblr for clowns")).to(haveSucceeded())
        }

        context("and a matcher is specified") {
          it("fails if the result's value doesn't match") {
            let message = assertionMessage {
              expect(success("runkeeper for recipies")).to(haveSucceeded(equal("seamless for dread")))
            }
            expect(message).to(equal("expected to equal <seamless for dread>, got <Success: runkeeper for recipies>"))
          }

          it("succeeds if the result's value matches") {
            expect(success([1, 2, 3])).to(haveSucceeded(contain(2)))
          }
        }
      }
    }
  }
}
