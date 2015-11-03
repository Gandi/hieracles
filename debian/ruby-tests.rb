$: << 'lib' << '.'
Dir['{spec}/**/*.rb'].each { |f| require f }

exec "rspec"
