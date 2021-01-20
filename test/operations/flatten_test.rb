require 'minitest/autorun'

require_relative '../../operations'

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

    assert_equal output, operation.operate(input)
  end

  def test_with_include_keys1
    operation = Operations::Flatten.new(include_keys: ['node0.0'])

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
      "node0.0_node1.1" => {
        "node2.0" => "example2",
        "node2.1" => 1,
        "node2.2" => true
      },
      "node0.0_node1.2" => "example3"
    }

    assert_equal output, operation.operate(input)
  end

  def test_with_include_keys2
    operation = Operations::Flatten.new(include_keys: ['node0.0.node1.1'])

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
        "node1.1_node2.0" => "example2",
        "node1.1_node2.1" => 1,
        "node1.1_node2.2" => true,
        "node1.2" => "example3"
      }
    }

    assert_equal output, operation.operate(input)
  end

  def test_with_exclude_keys1
    operation = Operations::Flatten.new(exclude_keys: ['node0.0.node1.1'])

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
      "node0.0_node1.1" => {
        "node2.0" => "example2",
        "node2.1" => 1,
        "node2.2" => true
      },
      "node0.0_node1.2" => "example3"
    }

    assert_equal output, operation.operate(input)
  end

  def test_with_exclude_keys2
    operation = Operations::Flatten.new(exclude_keys: ['node0.0'])

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
        "node1.1_node2.0" => "example2",
        "node1.1_node2.1" => 1,
        "node1.1_node2.2" => true,
        "node1.2" => "example3"
      }
    }

    assert_equal output, operation.operate(input)
  end
end
