require_relative '../../operations'

require 'minitest/autorun'

class Operations::ToKeyValueArrayTest < Minitest::Test
  def test_1
    operation = Operations::ToKeyValueArray.new

    input = {
      "node0.0" => {
        "node1.0" => "example1",
        "node1.1" => {
          "node2.0" => "example2",
          "node2.1" => 1,
          "node2.2" => true
        },
        "node1.2" => "example3"
      }
    }
    output = {
      "node0.0.key" => ["node1.0", "node1.1.key", "node1.1.value", "node1.2"],
      "node0.0.value" => [
        "example1",
        ["node2.0", "node2.1", "node2.2"],
        ["example2", 1, true],
        "example3"
      ]
    }

    assert_equal output, operation.operate(input)
  end

  def test_with_keys
    operation = Operations::ToKeyValueArray.new(keys: ['node0.0'])

    input = {
      "node0.0" => {
        "node1.0" => "example1",
        "node1.1" => {
          "node2.0" => "example2",
          "node2.1" => 1,
          "node2.2" => true
        },
        "node1.2" => "example3"
      }
    }
    output = {
      "node0.0.key" => ["node1.0", "node1.1", "node1.2"],
      "node0.0.value" => [
        "example1",
        {
          "node2.0" => "example2",
          "node2.1" => 1,
          "node2.2" => true
        },
        "example3"
      ]
    }

    assert_equal output, operation.operate(input)
  end
end
