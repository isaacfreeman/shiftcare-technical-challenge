# frozen_string_literal: true

require 'irb'

require_relative '../client'
require_relative '../client_list'

# Wraps the ClientList#find_matches method, providing output for a command
# line UI.
class FindMatches
  def initialize; end

  def call(query:, field: nil, data_path: nil)
    data_path ||= 'clients.json'
    field ||= :full_name

    client_list = ClientList.from_json_file(data_path)

    matching_clients = client_list.find_matches(regex_query: query, field: field.to_sym)

    puts "Clients matching '#{query}'"
    matching_clients.each do |matching_client|
      puts "  #{matching_client}"
    end
  end
end
