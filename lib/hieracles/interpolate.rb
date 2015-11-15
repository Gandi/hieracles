module Hieracles
  module Interpolate

    def parse(data, values, interactive = false)
      data.gsub(/%\{(?:(scope|hiera|literal|alias) *)?([^\}]*)\}/) do |match|
        if interactive && !values[$2.to_sym]
          puts
          puts "#{match} is not defined."
          puts "Is it missing in your ENC source?"
          puts "Maybe you should define a default value for that scope variable in your config file?"
          puts "Do you want to provide a temmporary value? [input value]"
          print "#{$2} = "
          val = $stdin.gets.chomp
          values[$2.to_sym] = val
          val
        else
          values[$2.to_sym]
        end
      end
    end

  end
end
