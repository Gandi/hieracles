module Hieracles
  module Utils

    def to_shallow_hash(hash)
      hash.reduce({}) do |shallow_hash, (key, value)|
        if value.is_a?(Hash)
          to_shallow_hash(value).each do |sub_key, sub_value|
            shallow_hash[[key, sub_key].join('.')] = sub_value
          end
        else
          shallow_hash[key.to_s] = value
        end
        shallow_hash
      end
    end

    def to_deep_hash(hash)
      hash.reduce({}) do |a, (key, value)|
        keys = key.to_s.split('.').reverse
        leaf_key = keys.shift
        key_hash = keys.reduce(leaf_key.to_sym => value) { |h, k| { k.to_sym => h } }
        deep_merge!(a, key_hash)
        a
      end
    end
    
    def deep_merge!(hash1, hash2)
      merger = proc { |key, v1, v2| v1.is_a?(Hash) && v2.is_a?(Hash) ? v1.merge(v2, &merger) : v2 }
      hash1.merge!(hash2, &merger)
    end

    def deep_sort(object)
      if object.is_a?(Hash)
        res = {}
        object.each { |k, v| res[k] = deep_sort(v) }
        Hash[res.sort { |a, b| a[0].to_s <=> b[0].to_s }]
      elsif object.is_a?(Array)
        if object[0].is_a?(Hash) || object[0].is_a?(Array)
          array = []
          object.each_with_index { |v, i| array[i] = deep_sort(v) }
          array
        else
          object.sort
        end
      else
        object
      end
    end

    def max_key_length(hash)
      hash.keys.reduce(0) { |a, x| (x.length > a) ? x.length : a }
    end

    def sym_keys(hash)
      hash.reduce({}) { |a, (k, v)| a[k.to_sym] = v ; a }
    end

  end
end
