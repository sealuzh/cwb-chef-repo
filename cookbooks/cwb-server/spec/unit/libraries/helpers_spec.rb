# include CwbServer::Helpers
describe CwbServer::Helpers do
  describe 'env_pairs' do
    let(:envs) { { 'key1' => 'value1', 'key2' => 'value2' } }
    it 'transforms a hash into environment key-value pairs' do
      expect { env_pairs(envs) }.to eq("key1=value1\n
                                        key2=value2\n")
    end
  end
end
