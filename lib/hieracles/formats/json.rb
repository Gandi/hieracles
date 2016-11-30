require 'json/ext'

module Hieracles
  module Formats
    # format intended to be used for an api server
    class Json < Hieracles::Format

      def info(_)
        @node.info.merge(alerts).to_json
      end

      def facts(_)
        @node.facts.merge(alerts).to_json
      end

      def files(_)
        { 'files' => @node.files }.merge(alerts).to_json
      end

      def paths(_)
        { 'paths' => @node.paths }.merge(alerts).to_json
      end

      def modules(_)
        @node.modules.merge(alerts).to_json
      end

      def params(args)
        @node.params(true).merge(alerts).to_json
      end

      def allparams(args)
        @node.params(false).merge(alerts).to_json
      end

      def build_list(hash, notifications, filter)
        if filter[0]
          { 'notifications' => notifications,
            'payload' => hash.select { |k, e| Regexp.new(filter[0]).match k }
          }.to_json
        else
          { 'notifications' => notifications,
            'payload' => hash
          }.to_json
        end
      end

    private

      def alerts
        if @node.notifications.count > 0
          { 'alerts' => @node.notifications.map(&:to_hash) }
        else
          {}
        end
      end
    end
  end
end
