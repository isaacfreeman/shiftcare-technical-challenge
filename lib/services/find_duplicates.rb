# Prototype for Shiftcare technical challenge.

# Run from command line with `ruby prototype.rb`

require 'irb'
require './lib/client.rb'
require './lib/client_list.rb'

class FindDuplicates
  def initialize
  end

  def call(data_path: nil)
    data_path ||= 'clients.json'
    json_data = File.read(data_path)
    client_list = ClientList.from_json(json_data)

    puts "Clients with duplicate emails"
    duplicate_emails = client_list.find_duplicates

    duplicate_emails.each do |email, duplicate_clients|
      puts "#{email} appears #{duplicate_clients.count} times:"

      duplicate_clients.each do |duplicate_client|
        puts "  #{duplicate_client}"
      end
    end
  end
end
