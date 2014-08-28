module Support
  module ClientHelper
    shared_context "with client" do
      let!(:client) do
        Fulcrum::Client.new('apikey', 'http://example.com/api/v2')
      end
    end
  end
end
