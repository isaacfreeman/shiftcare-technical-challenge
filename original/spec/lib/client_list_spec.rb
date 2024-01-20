require_relative '../../lib/client_list'

describe ClientList do
  let(:client_list) { described_class.new(clients: client_list_clients) }
  let(:client_list_clients) {[client1, client2] }
  let(:client1) { Client.new(id: 1, full_name: "John Doe", email: "john.doe@example.com")}
  let(:client2) { Client.new(id: 2, full_name: "Jane Smith", email: "jane.smith@example.com")}

  describe ".from_json" do
    subject { ClientList.from_json(json_data) }
    let(:json_data) do
      <<~JSON
        [
          {
            "id": 1,
            "full_name": "John Doe",
            "email": "john.doe@example.com"
          },
          {
            "id": 2,
            "full_name": "Jane Smith",
            "email": "jane.smith@example.com"
          }
        ]
      JSON
    end

    it "builds a ClientList without error" do
      expect { subject }.not_to raise_error
    end

    context "when the JSON is poorly-formed" do
      let(:json_data) do
        <<~JSON
          [
            {
              "id": 1,
              "full_name": "John Doe",
              "email": "john.doe@example.com"
            }
        JSON
      end

      it "raises an error" do
        expect { subject }.to raise_error(JSON::ParserError)
      end
    end

    context "when the JSON is empty" do
      let(:json_data) { "" }
      it "raises an error" do
        expect { subject }.to raise_error(JSON::ParserError)
      end
    end
  end

  describe ".from_json_file" do
    subject { ClientList.from_json_file(data_path) }
    let(:data_path) { "#{RSPEC_ROOT}/fixtures/clients.json"}

    it "builds a ClientList without error" do
      expect { subject }.not_to raise_error
    end

    context "when the file can't be found" do
      let(:data_path) { "#{RSPEC_ROOT}/fixtures/flarn.json"}

      it "does soemthing sensible" do
        expect { subject }.to raise_error(Errno::ENOENT)
      end
    end
  end

  describe '#count' do
    subject { client_list.count }

    it "returns the number of clients" do
      expect(client_list.count).to eq 2
    end
  end

  describe '#find_duplicates' do
    subject { client_list.find_duplicates }

    context "when two clients have the same email address" do
      let(:client1) { Client.new(id: 1, full_name: "John Doe", email: "john.doe@example.com")}
      let(:client2) { Client.new(id: 2, full_name: "Jane Smith", email: "john.doe@example.com")}

      it "returns them" do
        expect(subject).to eq(
          {
            "john.doe@example.com" => [client1, client2]
          }
        )
      end
    end

    context "when there are no duplicates" do
      it "returns an empty hash" do
        expect(subject).to eq({})
      end
    end

    context "when given an additional field argument" do
      subject { client_list.find_duplicates(field: field) }

      let(:field) { :full_name }

      let(:client1) { Client.new(id: 1, full_name: "John Doe", email: "john.doe@example.com")}
      let(:client2) { Client.new(id: 2, full_name: "John Doe", email: "john.doe.alternate.email@example.com")}

      it "returns duplicates from the specified field" do
        expect(subject).to eq(
          {
            "John Doe" => [client1, client2]
          }
        )
      end

      context "when the field is not on the permitted list" do
        let(:field) { :super_secret_data }

        it "raises an error" do
          expect { subject }.to raise_error(ClientList::UnknownFieldError)
        end
      end
    end
  end

  describe '#find_matches' do
    subject { client_list.find_matches(regex_query: query) }

    let(:query) { "Jane" }

    it "returns clients that match the given query" do
      expect(subject).to match_array([client2])
    end

    context "when the query is a regex" do
      let(:query) { "J.*Smith" }

      it "returns clients that match the given query" do
        expect(subject).to match_array([client2])
      end
    end

    context "when given an additional field argument" do
      subject { client_list.find_matches(regex_query: query, field: field) }

      let(:query) { "jane.smith@example.com" }
      let(:field) { :email }


      it "can match against the given field" do
        expect(subject).to match_array([client2])
      end

      context "when the field is not on the permitted list" do
        let(:field) { :super_secret_data }

        it "raises an error" do
          expect { subject }.to raise_error(ClientList::UnknownFieldError)
        end
      end
    end
  end
end
