require 'json'
require_relative './client'

class ClientList
  attr_reader :clients

  def initialize(clients:)
    @clients = clients
  end

  def self.from_json(json_data)
    clients = JSON.parse(json_data)
                  .map { |client_json| Client.from_hash(client_json) }
    ClientList.new(clients: clients)
  end

  def count
    @clients.count
  end

  def find_duplicates
    @clients.group_by { |client| client.email }
            .select { |email,clients| clients.count > 1}
  end

  def find_matches(regex_query:, field: :full_name)
    @clients.select do |client|
      client.public_send(field)
            .match(regex_query)
    end
  end
end
