require_relative 'base'

class Operations::ChangeValueType < Operations::Base
  def initialize(log_level: 'low', include_keys: [], exclude_keys: [], key_path_separator: '->', to_type:)
    super(log_level: log_level, include_keys: include_keys, exclude_keys: exclude_keys, key_path_separator: key_path_separator)
    @to_type = to_type
  end

  def operate(obj)
    _json_change_value_type(obj)
  end

  private

  def _json_change_value_type(json, key_path: nil)
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
        v = _json_change_value_type(v, key_path: key_path)
      end

      new_value = if _should_operate_key?(key_path)
        _convert_value(v)
      else
        v
      end

      if json.is_a?(Array)
        res << new_value
      else
        res[k] = new_value
      end
    end

    res
  end

  def _convert_value(value)
    case @to_type
    when 'string'
      value.to_s
    when 'integer'
      value.to_i
    when 'float'
      value.to_f
    end
  end
end
