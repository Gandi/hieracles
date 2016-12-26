
module Hieracles
  class Commands

    attr_reader :available

    def initialize(config)
      @config = config
      @formatter = Object.const_get("Hieracles::Formats::#{@config.format}")
      @available = %w(info files params paths modules allparams facts)
    end

    def run(command, arg, extra)
      if arg and arg[/\./] # poor way to detect if it is a fqdn
        if Hieracles::Registry.nodes(@config).include? arg
          puts call_node(command.to_sym, arg, extra)
        else
          puts "node '#{arg}' not found"
        end
      else
        if respond_to? command
          send command.to_sym, arg, extra
        else
          # not a node
          puts "'#{arg}' is not a FQDN."
        end
      end
    end

    def farms(arg, extra)
      if arg
        arg = [arg]
      else
        arg = []
      end
      formatter = @formatter.new nil
      farms = Hieracles::Registry.farms_nodes(@config, 'local', true)
      puts formatter.build_list(farms, nil, arg)
    end

    def modules(arg, extra)
      if arg
        arg = [arg]
      else
        arg = []
      end
      formatter = @formatter.new nil
      modules = Hieracles::Registry.nodes_modules(@config, 'local', arg)
      puts formatter.build_list(modules, nil, arg)
    end

    def call_node(command, fqdn, extra)
      node = Hieracles::Node.new fqdn, @config
      formatter = @formatter.new node
      formatter.send command, extra
    end

  end
end
