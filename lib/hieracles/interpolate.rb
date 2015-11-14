module Hieracles
  module Interpolate

    def parse(data, values, interactive = false)
      data.gsub(/%\{(?:(scope|hiera|literal|alias) *)?([^\}]*)\}/) do |match|
        if interactive && !values[$2.to_sym]
          puts "#{match} not found"
        else
          values[$2.to_sym]
        end
      end
    end

  end
end
