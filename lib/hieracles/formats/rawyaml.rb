module Hieracles
  module Formats
    # format mostly useful for re-integration in param files
    class Rawyaml < Hieracles::Format

      def info(_)
        @node.info.to_yaml
      end

      def facts(_)
        @node.facts.to_yaml
      end

      def files(_)
        @node.files.to_yaml
      end

      def paths(_)
        @node.paths.to_yaml
      end

      def modules(_)
        @node.modules.to_yaml
      end

      def params(args)
        @node.params_tree(true).to_yaml
      end

      def allparams(args)
        @node.params_tree(false).to_yaml
      end
      
      def build_list(hash, notifications, filter)
        if filter[0]
          hash.select { |k, e| Regexp.new(filter[0]).match k }.to_yaml
        else
          hash.to_yaml
        end
      end

    end
  end
end
