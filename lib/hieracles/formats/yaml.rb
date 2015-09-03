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



    end

  end
end
