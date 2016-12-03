require 'json/ext'

module Hieracles
  module Formats
    # format intended to be used for an api server
    class Json < Hieracles::Format

      def info(args)
        filter(@node.info, args)
        @node.info.merge(alerts).to_json
      end

      def facts(args)
        filter(@node.facts, args)
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

      def filter(what, args)
        if args[0]
          what.select! { |k, v| Regexp.new(args[0]).match(k.to_s) }
        end
      end

    end
  end
end
