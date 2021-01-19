require 'ostruct'

class Configuration
  def initialize(source:)
    @config = source

    _verify!
  end

  %w(source destination).each do |node_type|
    define_method("#{node_type}") do
      @config[node_type]
    end

    define_method("#{node_type}_type") do
      @config[node_type]['type']
    end

    define_method("#{node_type}_data") do
      @config[node_type].except('type').transform_keys(&:to_sym)
    end
  end

  def operations
    @operations ||= @config['operations'].map do |operation|
      OpenStruct.new(
        type: operation['type'],
        data: operation.except('type').transform_keys(&:to_sym)
      )
    end
  end

  private

  def _verify!
    true
  end
end
