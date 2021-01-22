class Operations::Base
  attr_reader :log_level

  def initialize(log_level: 'low', include_keys: [], exclude_keys: [], key_path_separator: '->')
    @log_level = log_level
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

    if @include_keys.any? || @exclude_keys.any?
      given_key_parent = given_key.split(@key_path_separator)[0..-2].join(@key_path_separator)

      checks = [given_key.to_s, "#{given_key_parent}#{@key_path_separator}*"].map do |key_to_check|
        if @include_keys.any?
          @_keys.key?(key_to_check)
        else
          @_keys[key_to_check] != false
        end
      end

      if @include_keys.any?
        checks.any?
      else
        checks.all?
      end
    else
      true
    end
  end
end
