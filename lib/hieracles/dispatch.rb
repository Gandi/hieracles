module Hieracles
  class Dispatch

    def initialize(node)
      @node = node
    end

    def info(*args)
      puts "not implemented, please inherit from the Hieracles::Dispatch class to implement a format."
    end

    def files(*args)
      puts "not implemented, please inherit from the Hieracles::Dispatch class to implement a format."
    end

    def paths(*args)
      puts "not implemented, please inherit from the Hieracles::Dispatch class to implement a format."
    end

    def params(args)
      filter = args[0]
      @colors = {}
      output = ""
      output << build_head
      @node.params.each do |k, v|
        output << build_params_line(k, v, filter)
      end
      puts output
    end

    def allparams(args)
      @node.add_common
      params(args)
    end

    def modules(args)
      output = ""
      @node.modules.each do |k, v|
        output << build_modules_list(k, v)
      end
      puts output
    end

  protected

    def build_head
      puts "not implemented, please inherit from the Hieracles::Dispatch class to implement a format."
    end

    def build_params_line(key, value, filter)
      puts "not implemented, please inherit from the Hieracles::Dispatch class to implement a format."
    end

    def build_modules_list(key, value)
      puts "not implemented, please inherit from the Hieracles::Dispatch class to implement a format."
    end

  end
end
