module Hieracles
  module Interpolate

    def parse(data, values)
      data.gsub(/%(?:(scope|hiera|literal|alias) *)?\{([^\}]*)\}/0) do |match|
        puts match
      end
    end

  end
end
