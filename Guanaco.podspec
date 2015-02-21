Pod::Spec.new do |s|
  s.name = "Guanaco"
  s.version = "0.1.0"
  s.summary = "Nimble matchers for LlamaKit."
  s.description = <<-DESC
                  Testing algebraic data types like `LlamaKit.Result` can be a pain.
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

  # Although Guananco depends on LlamaKit, we cannot specify that dependency
  # because the latest version of LlamaKit that has been pushed to CocoaPods is v0.1.1.
  # See https://github.com/LlamaKit/LlamaKit/issues/33.
  # s.dependency 'LlamaKit', '~> 0.5'
end

