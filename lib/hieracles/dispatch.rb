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
      output
      if Config.format == 'raw'
        @node.modules.each do |k, v|
          puts v
        end
      else
        length = @node.modules.keys.reduce(0) { |a, x| (x.length > a) ? x.length : a } + 3
        puts color(3) % [@node.classfile]
        puts
        @node.modules.each do |k, v|
          val = "%s"
          val = color(0) if /not found/i.match v 
          val = color(2) if /\(duplicate\)/i.match v 
          puts "%-#{length}s #{val}" % [k, v]
        end
      end
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
