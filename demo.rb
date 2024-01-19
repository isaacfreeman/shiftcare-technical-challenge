# Prototype for Shiftcare technical challenge.

# Run from command line with `ruby prototype.rb`

require 'json'
require 'irb'
require './client.rb'
require './client_list.rb'

class Demo
  def initialize
  end

  def call(query)
    json_data = File.read('clients.json')
    client_list = ClientList.from_json(json_data)

    matching_clients = client_list.find_matches(query: query, field: :full_name)

    puts "Clients matching '#{query}'"
    matching_clients.each do |matching_client|
      puts "  #{matching_client}"
    end

    puts
    puts "Duplicates"
    duplicate_emails = client_list.find_duplicates

    duplicate_emails.each do |email, duplicate_clients|
      puts "#{email} appears #{client_list.count} times:"

      duplicate_clients.each do |duplicate_client|
        puts "  #{duplicate_client}"
      end
    end
  end
end
