require_relative '../../lib/client'

describe Client do
  let(:client) { described_class.new(id: 1, full_name: "John Doe", email: "john.doe@example.com") }

  describe ".from_hash" do
    subject { Client.from_hash(client_data) }
    let(:client_data) do
      {
        "id" => 1,
        "full_name" => "John Doe",
        "email" => "john.doe@example.com"
      }
    end

    it "builds a Client without error" do
      expect { subject }.not_to raise_error
    end

    context "when the hash is empty" do
      let(:client_data) { {} }

      it "raises an error" do
        expect { subject }.to raise_error(Client::MissingDataError)
      end
    end
  end

  describe '#to_s' do
    subject { client.to_s }

    it "uses the output from `inspect`" do
      expect(subject).to eq(client.inspect)
    end
  end
end
