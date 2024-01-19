# Prototype for Shiftcare technical challenge.

# Run from command line with `ruby prototype.rb`

require 'irb'
require './lib/client.rb'
require './lib/client_list.rb'

class FindMatches
  def initialize
  end

  def call(query)
    json_data = File.read('clients.json')
    client_list = ClientList.from_json(json_data)

    matching_clients = client_list.find_matches(regex_query: query, field: :full_name)

    puts "Clients matching '#{query}'"
    matching_clients.each do |matching_client|
      puts "  #{matching_client}"
    end
  end
end
