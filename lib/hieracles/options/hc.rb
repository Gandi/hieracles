require 'hieracles/optparse'

module Hieracles
  module Options
    class Hc < Hieracles::Optparse

      def available_options
        {
          config: {
            has_arg: true,
            aliases: ['c', 'conf', 'config']
          },
          format: {
            has_arg: true,
            aliases: ['f', 'format']
          },
          params: {
            has_arg: true,
            aliases: ['p', 'params']
          },
          hierafile: {
            has_arg: true,
            aliases: ['h', 'hierafile']
          },
          basepath: {
            has_arg: true,
            aliases: ['b', 'basepath']
          },
          encpath: {
            has_arg: true,
            aliases: ['e', 'encpath']
          },
          version: {
            has_arg: false,
            aliases: ['v', 'version']
          },
          yaml_facts: {
            has_arg: true,
            aliases: ['y', 'yaml']
          },
          json_facts: {
            has_arg: true,
            aliases: ['j', 'json']
          },
          interactive: {
            has_arg: false,
            aliases: ['i', 'interactive']
          },
          db: {
            has_arg: false,
            aliases: ['db']
          },
          nodb: {
            has_arg: false,
            aliases: ['nodb', 'no-db', 'no']
          }
        }
      end

      def self.usage
        return <<-END

Usage: hc <fqdn> <command> [extra_args]

Available commands:
  info        provides the farm, datacenter, country
              associated to the given fqdn
              An extra param can be added for filtering
              eg. hc <fqdn> info timestamp
              eg. hc <fqdn> info farm
  facts       lists facts, either provided as a fact file
              or grabbed from puppetdb.
              An extra param can be added for filtering
              eg. hc <fqdn> facts architecture
              eg. hc <fqdn> facts 'memory.*mb'
  files       list all files containing params affecting this fqdn
              (in more than commons)
  paths       list all file paths for files with params
  modules     list modules included in the farm where the node is
  params      list params for the node matching the fqdn
              An extra filter string can be added to limit the list
              use ruby regexp without the enclosing slashes
              eg. hc <fqdn> params postfix.*version
              eg. hc <fqdn> params '^postfix'
              eg. hc <fqdn> params 'version$'
  allparams   same as params but including the common.yaml params (huge)
              Also accepts a search string

Extra args:
  -f <plain|console|csv|yaml|rawyaml|json> default console
  -p extraparam=what,anotherparam=this 
  -c <configfile>
  -h <hierafile>
  -b <basepath> default ./
  -e <encdir>
  -y <fact_file> - facts in yaml format
  -j <fact_file> - facts in json format
  -v just displays the version of Hieracles
  -i - interactive mode
  -db - query puppetdb
  -nodb - do not query puppetdb
        END
      end


    end
  end
end
    
