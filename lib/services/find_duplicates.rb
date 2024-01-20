require 'irb'

require_relative '../client.rb'
require_relative '../client_list.rb'

class FindDuplicates
  def initialize
  end

  def call(field: nil, data_path: nil)
    data_path ||= 'clients.json'
    field ||= :email

    client_list = ClientList.from_json_file(data_path)

    puts "Clients with duplicate #{field}"
    duplicate_emails = client_list.find_duplicates(field: field.to_sym)

    duplicate_emails.each do |email, duplicate_clients|
      puts "#{email} appears #{duplicate_clients.count} times:"

      duplicate_clients.each do |duplicate_client|
        puts "  #{duplicate_client}"
      end
    end
  end
end
