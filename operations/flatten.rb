require_relative 'base'

class Operations::Flatten < Operations::Base
  def operate(obj)
    _flat_json(obj, separator: '_')
  end

  private

  def _flat_json(json, key_path: nil, parent_prefix: nil, separator: '.')
    res = {}
    object_key_path = key_path

    json.each_with_index do |elem, i|
      if elem.is_a?(Array)
        k, v = elem
      else
        k, v = i, elem
      end

      # keep track of nested object names
      key_path = object_key_path ? "#{object_key_path}#{@key_path_separator}#{k}" : k
      # assign key name for result hash
      key = parent_prefix ? "#{parent_prefix}#{separator}#{k}" : k

      has_enumerable_value = v.is_a?(Enumerable)
      if has_enumerable_value
        # recursive call to flatten child elements
        v = _flat_json(v, key_path: key_path, parent_prefix: _should_operate_key?(key_path) ? key : nil, separator: separator)
      end

      if _should_operate_key?(key_path)
        if has_enumerable_value
          res.merge!(v)
        else
          res[key] = v
        end
      else
        res[key] = v
      end
    end

    res
  end
end
