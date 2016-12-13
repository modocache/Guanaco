import Quick
import Nimble
import Result
import Guanaco

class HaveFailedSpec: QuickSpec {
  override func spec() {
    describe("haveFailed") {
      var actual: Result<[Int], NSError>!

      context("when the actual value is a success") {
        beforeEach {
          actual = Result.success([8, 6, 7, 5, 3, 0, 9])
        }

        it("fails") {
          let message = assertionMessage {
            expect(actual).to(haveFailed())
          }
          expect(message).to(match("expected to have failed"))
        }
      }

      context("when the actual value is a failure") {
        beforeEach {
          actual = Result.failure(NSError(
            domain: "twitter for grammar",
            code: 8675309,
            userInfo: [NSLocalizedDescriptionKey: "uber for philosophers"]
          ))
        }

        it("doesn't fail") {
          expect(actual).to(haveFailed())
        }

        context("and matchers are specified") {
          it("doesn't fail if the result's error values match") {
            expect(actual).to(haveFailed(beAnError(
              domain: equal("twitter for grammar"),
              code: beGreaterThan(-1),
              localizedDescription: match("uber")
            )))
          }

          it("fails if the result's error values don't match") {
            let message = assertionMessage {
              expect(actual).to(haveFailed(beAnError(
                domain: equal("twitter for grammar"),
                code: beGreaterThan(-1),
                localizedDescription: match("techcrunch")
              )))
            }
            expect(message).to(match("expected for failure value to match"))
          }
        }
      }
      
      context("when the expression throws error") {
        it("doesn't fail") {
          let actual: () throws -> Result<Any, NSError> = {
            
            throw NSError(
              domain: "twitter for grammar",
              code: 8675309,
              userInfo: [NSLocalizedDescriptionKey: "uber for philosophers"]
              )
          }
          
          expect(expression:actual).to(haveFailed())
        }
      }
        it("fail if the error thrown is of different type to the result's type") {
          enum Error : Swift.Error { case Unknown }

          let actual: () throws -> Result<Any, NSError> = {
            throw Error.Unknown
          }
          
          expect(expression:actual).toNot(haveFailed())
        }
    }
  }
}
