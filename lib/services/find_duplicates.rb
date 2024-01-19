# Prototype for Shiftcare technical challenge.

# Run from command line with `ruby prototype.rb`

require 'json'
require 'irb'
require './client.rb'
require './client_list.rb'

class FindDuplicates
  def initialize
  end

  def call
    json_data = File.read('clients.json')
    client_list = ClientList.from_json(json_data)

    puts "Clients with duplicate emails"
    duplicate_emails = client_list.find_duplicates

    duplicate_emails.each do |email, duplicate_clients|
      puts "#{email} appears #{client_list.count} times:"

      duplicate_clients.each do |duplicate_client|
        puts "  #{duplicate_client}"
      end
    end
  end
end
