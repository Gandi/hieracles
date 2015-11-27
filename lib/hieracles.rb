require 'hieracles/interpolate'
require 'hieracles/optparse'
require 'hieracles/config'
require 'hieracles/hiera'
require 'hieracles/utils'
require 'hieracles/help'
require 'hieracles/node'
require 'hieracles/format'
require 'hieracles/registry'
require 'hieracles/formats/csv'
require 'hieracles/formats/json'
require 'hieracles/formats/yaml'
require 'hieracles/formats/plain'
require 'hieracles/formats/console'
require 'hieracles/formats/rawyaml'
require 'hieracles/puppetdb'

# https://github.com/Gandi/hieracles
module Hieracles
  def self.version
    File.read(File.expand_path('../../CHANGELOG.md', __FILE__))[/([0-9]+\.[0-9]+\.[0-9]+)/]
  end
end
