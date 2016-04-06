Pod::Spec.new do |s|
  s.name = "Guanaco"
  s.version = "0.2.0"
  s.summary = "Nimble matchers for Result."
  s.description = <<-DESC
                  Testing algebraic data types like `Result` can be a pain.
                  For example, if you had a result of type `Result<Int, NSError>`, and
                  wanted to test that it had a successful value of `10`, you'd have to
                  write:

                  ```swift
                  switch result {
                  　case .Success(let value): XCTAssertEquals(value, 10)
                  　case .Failure(let error): XCTFail()
                  }
                  ```

                  Tests should be clear, consise, and provide useful failure messages--in
                  other words, the code above isn't going to cut it! Instead, use Guanaco
                  to write:

                  ```swift
                  expect(result).to(haveSucceeded(equal(10)))
                  ```
                  DESC
  s.homepage = "https://github.com/modocache/Guanaco"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "modocache" => "modocache@gmail.com" }
  s.social_media_url = "http://twitter.com/modocache"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.source = { :git => "https://github.com/modocache/Guanaco.git", :tag => "v#{s.version}" }
  s.source_files = "Guanaco", "Guanaco/**/*.{h,swift}"
  s.dependency 'Nimble', '~> 0.3.0'
  s.frameworks = ['XCTest']
end

