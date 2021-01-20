class Operations::Base
  def initialize(keys: [], key_path_separator: '.')
    @keys = keys
    @key_path_separator = key_path_separator
  end

  protected

  def _should_operate_key?(given_key)
    if !defined?(@_keys)
      @_keys ||= {}
      @keys.each do |_key|
        @_keys[_key.to_s] = true
      end
    end

    @keys.empty? || @_keys.key?(given_key.to_s)
  end
end
