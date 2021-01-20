require 'minitest/autorun'

require_relative '../../operations'

class Operations::ChangeValueTypeTest < Minitest::Test
  def test_1
    operation = Operations::ChangeValueType.new(to_type: 'string')

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
          "node2.0" => "example2",
          "node2.1" => "1",
          "node2.2" => "true"
        },
        "node1.2" => "example3"
      }
    }

    assert_equal output, operation.operate(input)
  end

  def test_with_include_keys1
    operation = Operations::ChangeValueType.new(include_keys: ['node0.0->node1.1->node2.1'], to_type: 'string')

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
          "node2.0" => "example2",
          "node2.1" => "1",
          "node2.2" => true
        },
        "node1.2" => "example3"
      }
    }

    assert_equal output, operation.operate(input)
  end

  def test_with_include_keys2
    operation = Operations::ChangeValueType.new(include_keys: ['node0.0->node1.1->node2.1->*'], to_type: 'string')

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
          "node2.1" => ["1", "2", "3"],
          "node2.2" => true
        },
        "node1.2" => "example3"
      }
    }

    assert_equal output, operation.operate(input)
  end

  def test_with_include_keys3
    operation = Operations::ChangeValueType.new(include_keys: ['node0.0->node1.1->node2.1->*'], to_type: 'string')

    input = {
      "node0.0" => {
        "node1.0" => "example1",
        "node1.1" => {
          "node2.0" => "example2",
          "node2.1" => [
            1,
            {
              "node3.0": "example4"
            },
            3
          ],
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
          "node2.1" => [
            "1",
            {
              "node3.0": "example4"
            },
            "3"
          ],
          "node2.2" => true
        },
        "node1.2" => "example3"
      }
    }

    assert_equal output, operation.operate(input)
  end

  def test_with_exclude_keys1
    operation = Operations::ChangeValueType.new(exclude_keys: ['node0.0->node1.1->node2.1'], to_type: 'string')

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
          "node2.0" => "example2",
          "node2.1" => 1,
          "node2.2" => "true"
        },
        "node1.2" => "example3"
      }
    }

    assert_equal output, operation.operate(input)
  end

  def test_with_exclude_keys2
    operation = Operations::ChangeValueType.new(exclude_keys: ['node0.0->node1.1->node2.2'], to_type: 'integer')

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
        "node1.0" => 0,
        "node1.1" => {
          "node2.0" => 0,
          "node2.1" => 1,
          "node2.2" => true
        },
        "node1.2" => 0
      }
    }

    assert_equal output, operation.operate(input)
  end

  def test_with_exclude_keys3
    operation = Operations::ChangeValueType.new(exclude_keys: ['node0.0->node1.1->*'], to_type: 'integer')

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
        "node1.0" => 0,
        "node1.1" => {
          "node2.0" => "example2",
          "node2.1" => 1,
          "node2.2" => true
        },
        "node1.2" => 0
      }
    }

    assert_equal output, operation.operate(input)
  end
end
