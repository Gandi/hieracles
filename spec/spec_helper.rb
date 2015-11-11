$LOAD_PATH << File.expand_path('../../lib', __FILE__)

if !ENV['BUILD']
  require 'rubygems'
  require 'bundler'

  if ENV['COV']
    require 'simplecov'
    SimpleCov.profiles.define :app do
      add_group 'bin', '/bin'
      add_group 'lib', '/lib'
      add_filter '/vendor/'
      add_filter '/spec/'
    end
    SimpleCov.start :app
  else
    #require 'coveralls'
    #Coveralls.wear!
    require "codeclimate-test-reporter"
    CodeClimate::TestReporter.start
  end
end

require 'hieracles'

RSpec.configure do |config|
  config.mock_with :rspec
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
