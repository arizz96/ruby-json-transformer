require_relative 'base'

class Operations::KeepKeys < Operations::Base
  def operate(obj)
    _json_keep_keys(obj)
  end

  private

  def _json_keep_keys(json, key_path: nil)
    res = {}
    object_key_path = key_path

    json.each do |k, v|
      # keep track of nested object names
      key_path = object_key_path ? "#{object_key_path}#{@key_path_separator}#{k}" : k

      if v.is_a?(Enumerable)
        # recursive call to key-valueize child elements
        v = _json_keep_keys(v, key_path: key_path)
      end

      if _should_operate_key?(key_path)
        res[k] = v
      end
    end

    res
  end
end
