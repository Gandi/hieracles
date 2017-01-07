module Hieracles
  class Farm

    def initialize(name, config)
      @name = name
      @config = config
    end

    def nodes()
    end

    def modules()
      regex = Regexp.new('\s*include\s*([-_a-z0-9]*)')
      extract_path = Regexp.new(".*#{@config.classpath.sub(/%s/,'([^/]*)')}")
      Dir.glob(format(@config.classpath, '*')).sort.reduce({}) do |a, f|
        name = f.sub(extract_path, "\\1")
        a[name] = find_item(f, regex)
        a
      end
    end

  end
end
