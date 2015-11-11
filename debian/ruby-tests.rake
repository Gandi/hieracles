require 'rspec/core/rake_task'

ENV['BUILD'] = '1'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['-c', '-f progress', '-r ./spec/spec_helper.rb']
  t.pattern = 'spec/lib/**/*_spec.rb'
end

task :default => :spec
