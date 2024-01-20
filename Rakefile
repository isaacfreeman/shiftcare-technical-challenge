# frozen_string_literal: true

require './lib/services/find_matches'
require './lib/services/find_duplicates'

namespace :clients do
  desc 'Find clients that match a given query. Optionally specify the field to match and path to the source JSON data.'
  task :find_matches do
    query = arguments[0]
    field = arguments[1]
    data_path = arguments[2]

    FindMatches.new.call(query: query, field: field, data_path: data_path)
  end

  desc 'Find clients with duplicate values for a given field. Optionally specify the field and path to the source JSON data.'
  task :find_duplicates do
    field = arguments[0]
    data_path = arguments[1]

    FindDuplicates.new.call(field: field, data_path: data_path)
  end
end

# This is a common;y-used trick to support command-line arguments in Rake.
# Rake assumes that each component of the command line represents a Rake task.
# e.g. if we call `rake demo Isabella` it expects to call tasks named `demo`
#      and  `Isabella`
# The first line here creates placeholder tasks for each argument to keep Rake
# happy. Technically it calls `demo` then `Isabella`, but `Isabella` doesn't
# need to do anything.
def arguments
  ARGV.each { |a| task a.to_sym do; end }
  ARGV.drop(1)
end
