class Operations::Base
  def initialize(include_keys: [], exclude_keys: [], key_path_separator: '.')
    @include_keys = include_keys
    @exclude_keys = exclude_keys
    @key_path_separator = key_path_separator
  end

  protected

  def _should_operate_key?(given_key)
    if !defined?(@_keys)
      @_keys ||= {}
      @include_keys.each do |included_key|
        @_keys[included_key.to_s] = true
      end
      @exclude_keys.each do |excluded_key|
        @_keys[excluded_key.to_s] = false
      end
    end

    if @include_keys.any?
      @_keys.key?(given_key.to_s)
    elsif @exclude_keys.any?
      @_keys[given_key.to_s] != false
    else
      true
    end
  end
end
