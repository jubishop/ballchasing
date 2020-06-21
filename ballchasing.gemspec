Gem::Specification.new do |spec|
  spec.name          = "ballchasing"
  spec.version       = "1.0"
  spec.date          = "2020-05-25"
  spec.summary       = %q{A Ruby library for ballchasing.com API}
  spec.authors       = ["Justin Bishop"]
  spec.email         = ["jubishop@gmail.com"]
  spec.homepage      = "https://github.com/jubishop/ballchasing"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.1")
  spec.metadata["source_code_uri"] = "https://github.com/jubishop/ballchasing"
  spec.files         = Dir["lib/**/*.rb"]
  spec.add_runtime_dependency 'core'
  spec.add_runtime_dependency 'duration'
  spec.add_runtime_dependency 'http'
  spec.add_runtime_dependency 'rstruct'
end
