# include CwbServer::Helpers
require_relative '../../../libraries/helpers.rb'
describe CwbServer::Helpers do
  describe 'env_pairs' do
    let(:helper){ Object.new.extend(CwbServer::Helpers) }
    let(:envs) { { 'key1' => 'value1', 'key2' => 'value2' } }
    it 'transforms a hash into environment key-value pairs' do
      expect(helper.env_pairs(envs)).to eq("key1=value1\nkey2=value2")
    end
  end
end
