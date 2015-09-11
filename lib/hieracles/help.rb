module Hieracles
  module Help

    def self.usage
      return <<-END

      Usage: hc <fqdn> <command> [extra_args]

      Available commands:
        info        provides the farm, datacenter, country
                    associated to the given fqdn
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
        -f <plain|console|csv|yaml> default console
        -p extraparam=what;anotherparam=this 
        -c <configfile>
        -h <hierafile>
        -b <basepath> default ./
        -e <encdir>
      END
    end
  end
end
