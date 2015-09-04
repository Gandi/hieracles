module Hieracles
  module Formats
    # format mostly useful for re-integration in param files
    class Yaml < Hieracles::Format

      def info(*args)
        payload = {
          "node" => @node.fqdn,
          "farm" => @node.farm,
          "datacenter" => @node.datacenter,
          "country" => @node.country
        }
        payload.to_yaml
      end

      def files(*args)
        @node.files.to_yaml
      end

      def paths(*args)
        @node.paths.to_yaml
      end

      def build_head
        ''
      end

    end
  end
end
