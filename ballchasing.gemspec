Gem::Specification.new do |spec|
  spec.name          = 'ballchasing'
  spec.version       = '1.0'
  spec.summary       = %q(A Ruby library for the ballchasing.com API.)
  spec.authors       = ['Justin Bishop']
  spec.email         = ['jubishop@gmail.com']
  spec.homepage      = 'https://github.com/jubishop/ballchasing'
  spec.license       = 'MIT'
  spec.files         = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']
  spec.bindir        = 'bin'
  spec.executables   = []
  spec.metadata      = {
    'source_code_uri' => 'https://github.com/jubishop/ballchasing',
    'steep_types' => 'sig'
  }
  spec.required_ruby_version = Gem::Requirement.new('>= 3.0')
  spec.add_runtime_dependency('core')
  spec.add_runtime_dependency('date')
  spec.add_runtime_dependency('duration')
  spec.add_runtime_dependency('http')
  spec.add_runtime_dependency('json')
  spec.add_runtime_dependency('rstruct')
end
