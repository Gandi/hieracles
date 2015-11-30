require 'json/ext'

module Hieracles
  module Formats
    # format intended to be used for an api server
    class Json < Hieracles::Format

      def info(_)
        @node.info.to_json
      end

      def facts(_)
        @node.facts.to_json
      end

      def files(_)
        @node.files.to_json
      end

      def paths(_)
        @node.paths.to_json
      end

      def modules(_)
        @node.modules.to_json
      end

      def params(args)
        @node.params(true).to_json
      end

      def allparams(args)
        @node.params(false).to_json
      end

    end
  end
end
