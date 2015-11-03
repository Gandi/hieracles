# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "hieracles"
  spec.version       = File.read(File.expand_path('../CHANGELOG.md', __FILE__))[/([0-9]+\.[0-9]+\.[0-9]+)/]
  spec.authors       = ["mose"]
  spec.email         = ["mose@gandi.net"]
  spec.summary       = %q{CLI tool for Hiera parameters visualisation.}
  spec.description   = %q{CLI tool for Hiera parameters visualisation and analysis.}
  spec.homepage      = "https://github.com/Gandi/hieracles"
  spec.metadata      = { "changelog" => "https://github.com/Gandi/hieracles/blob/master/CHANGELOG.md" }
  spec.license       = "MIT"

  spec.files         = %w(
                        CHANGELOG.md
                        Gemfile
                        LICENSE
                        README.md
                        Rakefile
                        bin/hc
                        hieracles.gemspec
                        lib/hieracles.rb
                        lib/hieracles/config.rb
                        lib/hieracles/format.rb
                        lib/hieracles/formats/console.rb
                        lib/hieracles/formats/csv.rb
                        lib/hieracles/formats/plain.rb
                        lib/hieracles/formats/rawyaml.rb
                        lib/hieracles/formats/yaml.rb
                        lib/hieracles/help.rb
                        lib/hieracles/hiera.rb
                        lib/hieracles/node.rb
                        lib/hieracles/optparse.rb
                        lib/hieracles/registry.rb
                        lib/hieracles/utils.rb
                        )
  spec.executables   = ['hc']
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', "~> 3.0"
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'rubocop'

end
