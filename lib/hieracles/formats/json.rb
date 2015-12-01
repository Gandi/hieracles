require 'json/ext'

module Hieracles
  module Formats
    # format intended to be used for an api server
    class Json < Hieracles::Format

      def info(_)
        if @node.notifications.count > 0
          payload = @node.info
          payload['alerts'] = @node.notifications.map(&:to_hash)
        else
          payload = @node.info
        end
        payload.to_json
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
