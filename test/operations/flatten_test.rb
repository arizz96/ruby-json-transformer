require_relative '../../operations'

require 'minitest/autorun'

class Operations::FlattenTest < Minitest::Test
  def test_1
    operation = Operations::Flatten.new

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
      "node0.0_node1.0" => "example1",
      "node0.0_node1.1_node2.0" => "example2",
      "node0.0_node1.1_node2.1" => 1,
      "node0.0_node1.1_node2.2" => true,
      "node0.0_node1.2" => "example3"
    }

    assert_equal operation.operate(input), output
  end
end
