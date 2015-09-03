module Hieracles
  class Format
    def initialize(node)
      @node = node
    end

    def info(_)
      "#{__callee__} not implemented, please inherit from the Hieracles::Format class to implement a format.\n"
    end

    def files(_)
      "#{__callee__} not implemented, please inherit from the Hieracles::Format class to implement a format.\n"
    end

    def paths(_)
      "#{__callee__} not implemented, please inherit from the Hieracles::Format class to implement a format.\n"
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
        output << build_modules_line(k, v)
      end
      output
    end

  protected

    def build_head
      "#{__callee__} not implemented, please inherit from the Hieracles::Format class to implement a format.\n"
    end

    def build_params_line(key, value, filter)
      "#{__callee__} not implemented, please inherit from the Hieracles::Format class to implement a format.\n"
    end

    def build_modules_line(key, value)
      "#{__callee__} not implemented, please inherit from the Hieracles::Format class to implement a format.\n"
    end
  end
end
