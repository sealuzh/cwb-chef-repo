module CwbServer
  module Helpers
    # Example:
    # { 'key1' => 'value1', 'key2' => 'value2'}
    # key1=value1
    # key2=value2
    def env_pairs(envs)
      envs.map { |k, v| "#{k}=#{v}" }.join("\n")
    end
  end
end
