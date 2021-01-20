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

      # recursive call to key-valueize child elements
      if v.is_a?(Array)
        v = v.map { |e| e.is_a?(Hash) ? _json_keep_keys(e, key_path: key_path) : e }
      elsif v.is_a?(Hash)
        v = _json_keep_keys(v, key_path: key_path)
      end

      if _should_operate_key?(key_path)
        res[k] = v
      end
    end

    res
  end
end
