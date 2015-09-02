module Hieracles
  module Formats

    class Csv < Hieracles::Dispatch

      def info(*args)
        puts [ @node.fqdn, @node.farm, @node.datacenter, @node.country ].join(',')
      end

      def files(*args)
        puts @node.files.join(',')
      end

      def paths(*args)
        puts @node.paths.join(',')
      end

    end

  end
end
