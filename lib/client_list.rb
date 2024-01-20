require 'json'

require_relative './client'

class ClientList
  attr_reader :clients

  class UnknownFieldError < StandardError; end

  def initialize(clients:)
    @clients = clients
  end

  def self.from_json(json_data)
    clients = JSON.parse(json_data)
                  .map { |client_json| Client.from_hash(client_json) }
    ClientList.new(clients: clients)
  end

  def self.from_json_file(data_path)
    json_data = File.read(data_path)
    from_json(json_data)
  end

  def count
    @clients.count
  end

  def find_duplicates(field: :email)
    raise UnknownFieldError unless Client::ALLOWED_QUERY_FIELDS.include?(field)

    @clients.group_by { |client| client.public_send(field) }
            .select { |email,clients| clients.count > 1}
  end

  def find_matches(regex_query:, field: :full_name)
    raise UnknownFieldError unless Client::ALLOWED_QUERY_FIELDS.include?(field)

    @clients.select do |client|
      client.public_send(field)
            .match(regex_query)
    end
  end
end
