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
      show_params(true, args)
    end

    def allparams(args)
      show_params(false, args)
    end

    def show_params(without_common, args)
      filter = args[0]
      output = build_head(without_common)
      @node.params(without_common).each do |k, v|
        output << build_params_line(k, v, filter)
      end
      output
    end

    def modules(args)
      output = ''
      @node.modules.each do |k, v|
        output << build_modules_line(k, v)
      end
      output
    end

  protected

    def build_head(without_common)
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
