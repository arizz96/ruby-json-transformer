class Operations::Flatten
  def initialize(); end

  def operate(obj)
    _flat_json(obj, separator: '_')
  end

  private

  def _flat_json(json, parent_prefix: nil, separator: '.')
    res = {}

    json.each_with_index do |elem, i|
      if elem.is_a?(Array)
        k, v = elem
      else
        k, v = i, elem
      end

      key = parent_prefix ? "#{parent_prefix}#{separator}#{k}" : k # assign key name for result hash

      if v.is_a?(Enumerable)
        res.merge!(_flat_json(v, parent_prefix: key, separator: separator)) # recursive call to flatten child elements
      else
        res[key] = v
      end
    end

    res
  end
end
