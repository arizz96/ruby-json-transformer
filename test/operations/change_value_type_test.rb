require 'minitest/autorun'

require_relative '../../operations'

class Operations::ChangeValueTypeTest < Minitest::Test
  # def test_1
  #   operation = Operations::ChangeValueType.new(to_type: 'string')

  #   input = {
  #     "node0.0" => {
  #       "node1.0" => "example1",
  #       "node1.1" => {
  #         "node2.0" => "example2",
  #         "node2.1" => 1,
  #         "node2.2" => true
  #       },
  #       "node1.2" => "example3"
  #     }
  #   }
  #   output = {
  #     "node0.0" => {
  #       "node1.0" => "example1",
  #       "node1.1" => {
  #         "node2.0" => "example2",
  #         "node2.1" => "1",
  #         "node2.2" => "true"
  #       },
  #       "node1.2" => "example3"
  #     }
  #   }

  #   assert_equal output, operation.operate(input)
  # end

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
            '{:"node3.0"=>"example4"}',
            "3"
          ],
          "node2.2" => true
        },
        "node1.2" => "example3"
      }
    }

    assert_equal output, operation.operate(input)
  end

  def test_with_include_keys4
    operation = Operations::ChangeValueType.new(include_keys: ['node0.0->node1.1'], to_type: 'string')

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
        "node1.1" => '{"node2.0"=>"example2", "node2.1"=>[1, {:"node3.0"=>"example4"}, 3], "node2.2"=>true}',
        "node1.2" => "example3"
      }
    }

    assert_equal output, operation.operate(input)
  end

  def test_with_include_keys5
    operation = Operations::ChangeValueType.new(include_keys: ['node0.0->node1.1->node2.1->*'], to_type: 'json_string')

    input = {
      "node0.0" => {
        "node1.0" => "example1",
        "node1.1" => {
          "node2.0" => "example2",
          "node2.1" => [
            1,
            { "node3.0" => "example4" },
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
            '{"node3.0":"example4"}',
            "3"
          ],
          "node2.2" => true
        },
        "node1.2" => "example3"
      }
    }

    assert_equal output, operation.operate(input)
  end

  def test_with_include_keys6
    operation = Operations::ChangeValueType.new(include_keys: ['node0.0->node1.1->node2.1->*'], to_type: 'json_string')

    input = {
      "node0.0" => {
        "node1.0" => "example1",
        "node1.1" => {
          "node2.0" => "example2",
          "node2.1" => [
            1,
            {
              "node3.0" => "example4",
              "node3.1" => [
                {
                  "node4.0" => "example5"
                }
              ]
            },
            [1, 2, 3]
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
            '{"node3.0":"example4","node3.1":[{"node4.0":"example5"}]}',
            '[1, 2, 3]'
          ],
          "node2.2" => true
        },
        "node1.2" => "example3"
      }
    }

    assert_equal output, operation.operate(input)
  end

  def test_with_exclude_keys1
    operation = Operations::ChangeValueType.new(exclude_keys: ['node0.0', 'node0.0->node1.1', 'node0.0->node1.1->*'], to_type: 'integer')

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
