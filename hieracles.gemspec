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
                        hc.1
                        bin/hc
                        hieracles.gemspec
                        lib/hieracles.rb
                        lib/hieracles/config.rb
                        lib/hieracles/format.rb
                        lib/hieracles/formats/console.rb
                        lib/hieracles/formats/csv.rb
                        lib/hieracles/formats/json.rb
                        lib/hieracles/formats/plain.rb
                        lib/hieracles/formats/rawyaml.rb
                        lib/hieracles/formats/yaml.rb
                        lib/hieracles/help.rb
                        lib/hieracles/hiera.rb
                        lib/hieracles/interpolate.rb
                        lib/hieracles/node.rb
                        lib/hieracles/optparse.rb
                        lib/hieracles/registry.rb
                        lib/hieracles/utils.rb
                        spec/files/config.yml
                        spec/files/enc/server.example.com.yaml
                        spec/files/enc/server2.example.com.yaml
                        spec/files/enc/server3.example.com.yaml
                        spec/files/enc/server4.example.com.yaml
                        spec/files/farm_modules/dev.pp
                        spec/files/farm_modules/dev2.pp
                        spec/files/farm_modules/dev4.pp
                        spec/files/hiera.yaml
                        spec/files/hiera_no_yamlbackend.yaml
                        spec/files/hiera_yamlbackend_notfound.yaml
                        spec/files/modules/fake_module/manifests/init.pp
                        spec/files/modules/fake_module2/manifests/init.pp
                        spec/files/modules/fake_module3/manifests/init.pp
                        spec/files/modules/faux_module1/manifests/init.pp
                        spec/files/modules/faux_module2/manifests/init.pp
                        spec/files/params/common/common.yml
                        spec/files/params/farm/dev.yaml
                        spec/files/params/nodes/server.example.com.yaml
                        spec/lib/config_spec.rb
                        spec/lib/format_spec.rb
                        spec/lib/formats/console_spec.rb
                        spec/lib/formats/csv_spec.rb
                        spec/lib/formats/json_spec.rb
                        spec/lib/formats/plain_spec.rb
                        spec/lib/formats/rawyaml_spec.rb
                        spec/lib/formats/yaml_spec.rb
                        spec/lib/help_spec.rb
                        spec/lib/hiera_spec.rb
                        spec/lib/node_spec.rb
                        spec/lib/optparse_spec.rb
                        spec/lib/registry_spec.rb
                        spec/lib/utils_spec.rb
                        spec/spec_helper.rb
                        )
  spec.executables   = ['hc']
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec', "~> 3.0"
  # spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'rubocop'

end
