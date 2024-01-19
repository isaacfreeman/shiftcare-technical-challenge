class Client
  attr_reader :id, :full_name, :email

  def initialize(id:, full_name:, email:)
    @id = id
    @full_name = full_name
    @email = email
  end

  # Initialize from JSON data
  def self.from_json(client_json)
    new(
      id: client_json["id"],
      full_name: client_json["full_name"],
      email: client_json["email"]
    )
  end

  def to_s
    self.inspect
  end
end
