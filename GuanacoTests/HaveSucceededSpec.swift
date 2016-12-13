import Quick
import Nimble
import Result
import Guanaco

class HaveSucceededSpec: QuickSpec {
  override func spec() {
    describe("haveSucceeded") {
      var actual: Result<String, NSError>!

      context("when the actual value is a failure") {
        beforeEach {
          actual = Result.failure(NSError(domain: "failure", code: 1, userInfo: nil))
        }

        it("fails") {
          let message = assertionMessage {
            expect(actual).to(haveSucceeded())
          }
          expect(message).to(match("expected to have succeeded, got"))
        }

        context("and a matcher is specified") {
          it("fails with a descriptive error message") {
            let message = assertionMessage {
              expect(actual).to(haveSucceeded(equal("dropbox for action items")))
            }
            expect(message).to(match("expected to have succeeded, got"))
          }
        }
      }

      context("when the actual value is a successful result") {
        beforeEach {
          actual = Result.success("tumblr for clowns")
        }

        it("doesn't fail") {
          expect(actual).to(haveSucceeded())
        }

        context("and a matcher is specified") {
          it("fails if the result's value doesn't match") {
            let message = assertionMessage {
              expect(actual).to(haveSucceeded(equal("seamless for dread")))
            }
            expect(message).to(equal("expected for successful value to equal <seamless for dread>, got <.success(tumblr for clowns)>"))
          }

          it("succeeds if the result's value matches") {
            expect(actual).to(haveSucceeded(match("clowns")))
          }
        }
      }
    }
  }
}
