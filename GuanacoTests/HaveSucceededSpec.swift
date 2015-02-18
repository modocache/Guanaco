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

        context("and an expected value is specified") {
          it("fails if the result doesn't have that value") {
            let message = assertionMessage {
              expect(success("runkeeper for recipies")).to(haveSucceeded("seamless for dread"))
            }
            expect(message).to(equal("expected to have succeeded with a value of seamless for dread, got <Success: runkeeper for recipies>"))
          }

          it("succeeds if the result has that value") {
            expect(success("github for pizza")).to(haveSucceeded("github for pizza"))
          }
        }
      }
    }
  }
}
