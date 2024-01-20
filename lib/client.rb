# frozen_string_literal: true

require 'json'

class Client
  ALLOWED_QUERY_FIELDS = %i[full_name email].freeze

  attr_reader :id, :full_name, :email

  class MissingDataError < StandardError; end

  def initialize(id:, full_name:, email:)
    @id = id
    @full_name = full_name
    @email = email
  end

  # Initialize from a hash of arguments
  def self.from_hash(client_data)
    raise MissingDataError if [client_data['id'], client_data['full_name'], client_data['email']].any?(&:nil?)

    new(
      id: client_data['id'],
      full_name: client_data['full_name'],
      email: client_data['email']
    )
  end

  def to_s
    inspect
  end
end
