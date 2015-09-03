module Hieracles
  class Dispatch
    def initialize(node)
      @node = node
    end

    def info(_)
      "not implemented, please inherit from the Hieracles::Dispatch class to implement a format.\n"
    end

    def files(_)
      "not implemented, please inherit from the Hieracles::Dispatch class to implement a format.\n"
    end

    def paths(_)
      "not implemented, please inherit from the Hieracles::Dispatch class to implement a format.\n"
    end

    def params(args)
      filter = args[0]
      @colors = {}
      output = ''
      output << build_head
      @node.params.each do |k, v|
        output << build_params_line(k, v, filter)
      end
      output
    end

    def allparams(args)
      @node.add_common
      params(args)
    end

    def modules(args)
      output = ''
      @node.modules.each do |k, v|
        output << build_modules_list(k, v)
      end
      output
    end

  protected

    def build_head
      "not implemented, please inherit from the Hieracles::Dispatch class to implement a format.\n"
    end

    def build_params_line(key, value, filter)
      "not implemented, please inherit from the Hieracles::Dispatch class to implement a format.\n"
    end

    def build_modules_list(key, value)
      "not implemented, please inherit from the Hieracles::Dispatch class to implement a format.\n"
    end
  end
end
