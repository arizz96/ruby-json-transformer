class Operations::KeepKeys
  def initialize(keys: [])
    @keys = keys
  end

  def operate(obj)
    _json_keep_keys(obj)
  end

  private

  def _json_keep_keys(json, parent_prefix: nil, separator: '.')
    res = {}

    json.each do |k, v|
      key = parent_prefix ? "#{parent_prefix}#{separator}#{k}" : k # keep track of nested object names

      if v.is_a?(Enumerable)
        # recursive call to key-valueize child elements
        v = _json_keep_keys(v, parent_prefix: key, separator: separator)
      end

      if _should_operate_key?(key)
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
