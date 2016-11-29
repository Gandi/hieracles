require 'hieracles/optparse'

module Hieracles
  module Options
    class Hieracles < Hieracles::Optparse

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
          }
        }
      end

      def self.usage
        return <<-END

Usage: hieracles <command> [extra_args]

Available commands:

  info <fqdn>
    provides the farm, datacenter, country
    associated to the given fqdn
    An extra param can be added for filtering
    eg. hieracles info <fqdn> timestamp
    eg. hieracles info <fqdn> farm

  files <fqdn|farm|module>
    list all files containing params affecting this fqdn
    (in more than commons)

  paths <fqdn|farm|module>
    list all file paths for files with params
  
  modules <fqdn>
    list modules included in the farm where the node is

  params <fqdn>
    list params for the node matching the fqdn
    An extra filter string can be added to limit the list
    use ruby regexp without the enclosing slashes
    eg. hieracles params <fqdn> postfix.*version
    eg. hieracles params <fqdn> '^postfix'
    eg. hieracles params <fqdn> 'version$'

  allparams <fqdn>
    same as params but including the common.yaml params (huge)
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
        END
      end


    end
  end
end
    
