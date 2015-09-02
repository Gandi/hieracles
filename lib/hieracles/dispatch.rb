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
      output << show_head
      @node.params.each do |k, v|
        output << show_params(k, v, filter)
      end
      puts output
    end

    def allparams(args)
      @node.add_common
      params(args)
    end

    def modules(args)
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

    def show_head
      output = ""
      @node.files.each_with_index do |f,i|
        output << color(i) % "[#{i}] #{f}"
        @colors[f] = i
      end
      "#{output}\n"
    end

    def show_params(key, value, filter)
      output = ""
      if !filter || Regexp.new(filter).match(k)
        first = value.shift
        begin
          output << "#{color(@colors[first[:file]])} #{color(5)} #{first[:value].to_s.gsub('%', '%%')}" % ["[#{@colors[first[:file]]}]", key]
        rescue
          output << "--debug----"
          output << "#{color(@colors[first[:file]])} #{color(5)} #{first[:value].to_s.gsub('%', '%%')}"
          output << "--/debug----"
        end
        while value.count > 0
          overriden = value.shift
          output << "    #{color(8)}" % ["[#{@colors[overriden[:file]]}] #{k} #{overriden[:value]}"]
        end
      end
      output
    end

  end

end
