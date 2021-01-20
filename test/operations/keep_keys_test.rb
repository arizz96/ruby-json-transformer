require 'minitest/autorun'

require_relative '../../operations'

class Operations::KeepKeysTest < Minitest::Test
  def test_1
    operation = Operations::KeepKeys.new(include_keys: ['node0.0', 'node0.0->node1.0', 'node0.0->node1.1', 'node0.0->node1.1->node2.0'])

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
      "node0.0" => {
        "node1.0" => "example1",
        "node1.1" => {
          "node2.0" => "example2"
        }
      }
    }

    assert_equal output, operation.operate(input)
  end

  def test_2
    operation = Operations::KeepKeys.new(include_keys: ['node0.0', 'node0.0->node1.0', 'node0.0->node1.1', 'node0.0->node1.1->node2.0', 'node0.0->node1.1->node2.1'])

    input = {
      "node0.0" => {
        "node1.0" => "example1",
        "node1.1" => {
          "node2.0" => "example2",
          "node2.1" => [1, 2, 3],
          "node2.2" => true
        },
        "node1.2" => "example3"
      }
    }
    output = {
      "node0.0" => {
        "node1.0" => "example1",
        "node1.1" => {
          "node2.0" => "example2",
          "node2.1" => [1, 2, 3]
        }
      }
    }

    assert_equal output, operation.operate(input)
  end
end
