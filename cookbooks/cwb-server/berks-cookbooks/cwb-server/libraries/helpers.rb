# Usage:
# Chef::Recipe.send(:include, CwbServer::Helpers)
module CwbServer
  module Helpers
    # Example:
    # { 'key1' => 'value1', 'key2' => 'value2'}
    # key1=value1
    # key2=value2
    def env_pairs(envs)
      envs.map { |k, v| "#{k}=#{v}" }.join("\n")
    end

    # Doubtful whether this works for Kitchen Dokken
    def test_env?
      !ENV['TEST_KITCHEN'].nil?
    end
  end
end
