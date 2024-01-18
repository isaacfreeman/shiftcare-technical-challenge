# Prototype for Shiftcare technical challenge.

# Run from command line with `ruby prototype.rb`

require 'json'
require 'irb'

json_data = File.read('clients.json')
clients = JSON.parse(json_data)

field_to_match = "full_name"
query = "Isabella"
matching_clients = clients.select{|client| client[field_to_match].match(query)}

puts "Clients matching '#{query}'"
matching_clients.each do |matching_client|
  puts "  #{matching_client}"
end

puts
puts "Duplicates"
duplicate_emails = clients.group_by { |client| client["email"] }
                          .select { |email,clients| clients.count > 1}

duplicate_emails.each do |email, duplicate_clients|
  puts "#{email} appears #{clients.count} times:"

  duplicate_clients.each do |duplicate_client|
    puts "  #{duplicate_client}"
  end
end
