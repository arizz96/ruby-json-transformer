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
      splitted_key_path = given_key.split(@key_path_separator)
      checks = splitted_key_path.map.with_index do |given_key_parent, i|
        # build key ancestors path
        given_key_parent = [
          *(splitted_key_path[0...i]),
          given_key_parent
        ].compact.join(@key_path_separator)

        # when checking ancestors, check for a ->* specified key
        key_to_check = if given_key_parent == given_key
          given_key.to_s
        else
          "#{given_key_parent}#{@key_path_separator}*"
        end

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
