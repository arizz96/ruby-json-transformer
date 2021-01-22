require 'hanami/utils/string'
require 'json'

require_relative 'sources'
require_relative 'operations'
require_relative 'destinations'

class Worker
  def initialize(configuration)
    @configuration = configuration
    @source = nil
    @operations = []
    @destination = nil

    _load_components
  end

  def process
    puts "Started worker processing with config:"
    puts JSON.pretty_generate(@configuration.config)
    puts

    @source.each_message do |message|
      _log(@source, message)

      res = message
      @operations.each do |operation|
        res = operation.operate(res)
        _log(operation, res)
      end

      _log(@destination, res)
      @destination.write_message(res)
    end
  end

  private

  def _class_from_string(string)
    Object.const_get(Hanami::Utils::String.new(string).classify)
  end

  def _class_module_name(object)
    object.class.to_s.split('::')[-2]
  end

  def _load_components
    @source = _class_from_string("sources::#{@configuration.source_type}").new(**@configuration.source_data)
    @destination = _class_from_string("destinations::#{@configuration.destination_type}").new(**@configuration.destination_data)

    @operations = @configuration.operations.map do |operation|
      _class_from_string("operations::#{operation.type}").new(**operation.data)
    end
  end

  def _log(step, message)
    puts "[#{step.class}] - handled message:" if %w(low med).include?(step.log_level)
    puts JSON.pretty_generate(message) if %w(med).include?(step.log_level)
    puts if %w(low med).include?(step.log_level) && _class_module_name(step) == 'Destinations'
  end
end
