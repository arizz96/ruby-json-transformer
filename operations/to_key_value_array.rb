class Operations::ToKeyValueArray
  def initialize(keys: [])
    @keys = keys
  end

  def operate(obj)
    _json_to_key_value_array(obj)
  end

  private

  def _json_to_key_value_array(json, parent_prefix: nil, separator: '.', key_name: 'key', value_name: 'value')
    res = {}

    json.each do |k, v|
      key = parent_prefix ? "#{parent_prefix}#{separator}#{k}" : k # keep track of nested object names

      if v.is_a?(Enumerable)
        # recursive call to key-valueize child elements
        v = _json_to_key_value_array(v, parent_prefix: key, separator: separator, key_name: key_name, value_name: value_name)
      end

      if v.is_a?(Enumerable) && _should_operate_key?(key)
        res["#{k}#{separator}#{key_name}"] = v.keys
        res["#{k}#{separator}#{value_name}"] = v.values
      else
        res[k] = v
      end
    end

    res
  end

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
