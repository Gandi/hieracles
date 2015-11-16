module Hieracles
  module Interpolate

    def parse(data, values, interactive = false)
      data.gsub(/%\{(?:(scope|hiera|literal|alias)\(['"])?([^\}"']*)(?:["']\))?\}/) do |match|
        if interactive && !values[$2.to_sym]
          values[$2.to_sym] = ask_about($2)
          val
        else
          values[$2.to_sym]
        end
      end
    end

    def ask_about(var)
      puts
      puts "'#{var}' is not defined."
      puts "Is it missing in your ENC source?"
      puts "Maybe you should define a default value for that scope variable in your config file?"
      puts "Do you want to provide a temmporary value? [input value]"
      print "#{var} = "
      $stdin.gets.chomp
    end

  end
end
