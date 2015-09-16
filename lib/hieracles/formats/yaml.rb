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
        commented_yaml_tree(true)
      end

      def allparams(args)
        commented_yaml_tree(false)
      end

      def commented_yaml_tree(without_common = true)
        tree = @node.params_tree(without_common)
        params = Hash[@node.params(without_common)]
        mergetree('---', [], tree, params)
      end

      def mergetree(output, key, leaf, params)
        indent = '  ' * key.count
        send("add_#{leaf.class.name.downcase}".to_sym, output, key, leaf, params, indent)
      end

      def add_hash(output, key, leaf, params, indent)
        leaf.each do |k, v|
          output += "\n" + indent + k + ': '
          output = mergetree(output, key + [k], v, params)
        end
        output
      end

      def add_array(output, key, leaf, params, indent)
        yaml = leaf.to_yaml[4..-1]
        aryaml = yaml.each_line.map do |l|
          indent + l
        end
        output += "\n" + indent + "# " + params[key.join('.')][0][:file]
        output += "\n" + aryaml.join().chomp
        output        
      end

      def add_string(output, key, leaf, params, indent)
        output += leaf
        if params["#{key.join('.')}"]
          output += " # " + params[key.join('.')][0][:file]
        end
        output
      end

    end
  end
end
