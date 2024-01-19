require './demo.rb'

task :demo do
  query = arguments.first

  Demo.new.call(query)
end

# This is a common;y-used trick to support command-line arguments in Rake.
# Rake assumes that each component of the command line represents a Rake task.
# e.g. if we call `rake demo Isabella` it expects to call tasks named `demo`
#      and  `Isabella`
# The first line here creates placeholder tasks for each argument to keep Rake
# happy. Technically it calls `demo` then `Isabella`, but `Isabella` doesn't
# need to do anything.
def arguments
  ARGV.each { |a| task a.to_sym do ; end }
  ARGV.drop(1)
end
