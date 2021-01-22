require_relative 'base'

class Operations::ToKeyValueArray < Operations::Base
  def operate(obj)
    _json_to_key_value_array(obj)
  end

  private

  def _json_to_key_value_array(json, key_path: nil, key_name: 'key', value_name: 'value', separator: '.')
    res = if json.is_a?(Array)
      []
    else
      {}
    end
    object_key_path = key_path

    json.each do |k, v|
      v = k if json.is_a?(Array)

      # keep track of nested object names
      key_path = object_key_path ? "#{object_key_path}#{@key_path_separator}#{k}" : k

      if v.is_a?(Enumerable)
        # recursive call to key-valueize child elements
        v = _json_to_key_value_array(v, key_path: key_path, key_name: key_name, value_name: value_name, separator: separator)
      end

      if v.is_a?(Enumerable) && _should_operate_key?(key_path)
        res["#{k}#{separator}#{key_name}"] = v.keys
        res["#{k}#{separator}#{value_name}"] = v.values
      elsif json.is_a?(Array)
        res << v
      else
        res[k] = v
      end
    end

    res
  end
end
