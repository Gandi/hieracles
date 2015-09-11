module Hieracles
  module Formats
    # format mostly useful for re-integration in param files
    class Yaml < Hieracles::Format

      def info(_)
        @node.info.to_yaml
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

    end
  end
end
