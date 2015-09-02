module Hieracles
  module Formats

    class Yaml < Hieracles::Dispatch

      def info(*args)
        payload = {
          "node" => @node.fqdn,
          "farm" => @node.farm,
          "datacenter" => @node.datacenter,
          "country" => @node.country
        }
        puts payload.to_yaml
      end

      def files(*args)
        puts @node.files.to_yaml
      end

      def paths(*args)
        puts @node.paths.to_yaml
      end

      def params(args)
        filter = args[0]
        colors = {}
        @node.files.each_with_index do |f,i|
          puts color(i) % "[#{i}] #{f}"
          colors[f] = i
        end
        puts
        @node.params.each do |k, v|
          if !filter || Regexp.new(filter).match(k)
            first = v.shift
            begin
              puts "#{color(colors[first[:file]])} #{color(5)} #{first[:value].to_s.gsub('%', '%%')}" % ["[#{colors[first[:file]]}]", k]
            rescue
              puts "--debug----"
              puts "#{color(colors[first[:file]])} #{color(5)} #{first[:value].to_s.gsub('%', '%%')}"
              puts "--/debug----"
            end
            while v.count > 0
              overriden = v.shift
              puts "    #{color(8)}" % ["[#{colors[overriden[:file]]}] #{k} #{overriden[:value]}"]
            end
          end
        end
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

    end

  end
end
