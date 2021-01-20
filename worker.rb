require 'hanami/utils/string'
require 'json'

require_relative 'sources'
require_relative 'operations'
require_relative 'destinations'

class Worker
  def initialize(config)
    @config = config
    @source = nil
    @operations = []
    @destination = nil

    _load_components
  end

  def process
    @source.each_message do |message|
      puts "[#{@source.class}] - read message:"
      puts JSON.pretty_generate(message)

      res = message
      @operations.each do |operation|
        puts "[#{operation.class}] - transformed message:"
        res = operation.operate(res)
        puts JSON.pretty_generate(res)
      end

      puts "[#{@source.class}] - writing message:"
      puts JSON.pretty_generate(res)
      puts
      @destination.write_message(res)
    end
  end

  private

  def _class_from_string(string)
    Object.const_get(Hanami::Utils::String.new(string).classify)
  end

  def _load_components
    @source = _class_from_string("sources::#{@config.source_type}").new(**@config.source_data)
    @destination = _class_from_string("destinations::#{@config.destination_type}").new(**@config.destination_data)

    @operations = @config.operations.map do |operation|
      _class_from_string("operations::#{operation.type}").new(**operation.data)
    end
  end
end
