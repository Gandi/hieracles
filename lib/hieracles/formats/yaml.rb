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

      def params(args = nil)
        if args 
          args = args.join(' ')
        end
        commented_yaml_tree(args, true)
      end

      def allparams(args = nil)
        if args 
          args = args.join('.')
        end
        commented_yaml_tree(args, false)
      end

      def commented_yaml_tree(filter, without_common = true)
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
        if @node.hiera.merge_behavior == :deep ||
           @node.hiera.merge_behavior == :deeper 
          params[key.join('.')].each do |f|
            output += "\n" + indent + "# " + f[:file]
          end
        else
          output += "\n" + indent + "# " + params[key.join('.')].last[:file]
        end
        output += "\n" + aryaml.join().chomp
        output        
      end

      def add_string(output, key, leaf, params, indent)
        added output, key, leaf, params
      end

      def add_fixnum(output, key, leaf, params, indent)
        added output, key, leaf, params
      end

      def add_float(output, key, leaf, params, indent)
        added output, key, leaf, params
      end

      def add_trueclass(output, key, leaf, params, indent)
        added output, key, 'true', params
      end

      def add_falseclass(output, key, leaf, params, indent)
        added output, key, 'false', params
      end

      def add_nilclass(output, key, leaf, params, indent)
        added output, key, '', params
      end

      private

      def added(output, key, leaf, params)
        output += leaf.to_s
        if params["#{key.join('.')}"]
          params["#{key.join('.')}"].each do |k|
            if k[:value].to_s == leaf.to_s
              output += " # " + k[:file]
              break
            end
          end
        end
        output
      end

    end
  end
end
