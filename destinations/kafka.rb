require 'kafka'

require_relative 'base'

class Destinations::Kafka < Destinations::Base
  def initialize(log_level: 'low', url:, topic:)
    super(log_level: log_level)
    @topic = topic
    @kafka = Kafka.new(url)
    @producer = @kafka.async_producer(
      delivery_threshold: 100,
      delivery_interval: 30
    )
  end

  def write_message(message)
    @producer.produce(message.to_s, topic: @topic)
  end
end
