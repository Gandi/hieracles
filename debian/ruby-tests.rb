$: << 'lib' << 'spec' << '.'
Dir['{spec}/**/*.rb'].each { |f| require f }

exec "rspec"
