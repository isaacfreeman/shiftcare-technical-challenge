# frozen_string_literal: true

require 'irb'

require_relative '../client'
require_relative '../client_list'

# Wraps the ClientList#find_duplicates method, providing output for a command
# line UI.
class FindDuplicates
  def initialize; end

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
