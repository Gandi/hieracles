module Hieracles
  module Interpolate

    def parse(data, values, interactive = false)
      data.gsub(/%\{(?:(scope|hiera|literal|alias)\(['"])?(?:::)?([^\}"']*)(?:["']\))?\}/) do |match|
        if interactive && !values[$2.to_sym]
          values[$2.to_sym] = ask_about($2)
          values[$2.to_sym]
        else
          values[$2.to_sym]
        end
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
    def setio(input, output)
      @@input = input
      @@output = output
    end

    # defaults to STDIN
    private def input
      @@input ||= STDIN
    end

    # defaults to STDOUT
    private def output
      @@output ||= STDOUT
    end

  end
end
