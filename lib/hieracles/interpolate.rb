module Hieracles
  module Interpolate

    def parse(data, values, interactive = false)
      data.gsub(regex) do |match|
        if interactive && !values[$2.to_sym]
          values[$2.to_sym] = ask_about($2)
          values[$2.to_sym]
        else
          values[$2.to_sym]
        end
      end
    end

    def extract(data)
      data.scan(regex).reduce([]) do |a, m|
        a << m[1] unless a.include?(m[1])
        a
      end
    end

    def ask_about(var)
      @@output.puts
      @@output.puts "'#{var}' is not defined."
      @@output.puts "Is it missing in your ENC source?"
      @@output.puts "Maybe you should define a default value for that scope variable in your config file?"
      @@output.puts "Do you want to provide a temmporary value? [input value]"
      @@output.print "#{var} = "
      @@input.gets.chomp
    end

    # makes possible to set input and output
    def setio(input=STDIN, output=STDOUT)
      @@input = input
      @@output = output
    end

    def regex
      /%\{(?:(scope|hiera|literal|alias)\(['"])?(?:::)?([^\}"']*)(?:["']\))?\}/
    end

  end
end
