
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "restclient/opentracing/version"

Gem::Specification.new do |spec|
  spec.name          = "restclient-opentracing"
  spec.version       = Restclient::Opentracing::VERSION
  spec.authors       = ["larte"]
  spec.email         = ["larte@foodie.fm"]

  spec.summary       = %q{Enable distributed tracing and intrumentation for restclient}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/foodie.fm/restclient-opentracing"
  spec.license       = "MIT"

  spec.metadata = {
    'bug_tracker_uri' => 'https://github.com/foodiefm/redisrb-opentracing/issues',
    'homepage_uri'    => 'https://github.com/foodiefm/redisrb-opentracing',
    'source_code_uri' => 'https://github.com/foodiefm/redisrb-opentracing',
  }
  spec.files         = %w(README.md Rakefile) + Dir.glob("{doc,lib}/**/*")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'opentracing_test_tracer', '~> 0.1'
  spec.add_development_dependency 'appraisal', '~> 2'
  spec.add_development_dependency 'rubocop', '~> 0.71.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.33.0'
  spec.add_development_dependency 'database_cleaner', '~> 1.7'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'webmock', '~> 3'

  spec.add_dependency 'rest-client', '~>2'
  spec.add_dependency 'opentracing', '~> 0.4'
end
