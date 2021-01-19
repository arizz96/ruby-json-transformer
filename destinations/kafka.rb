require 'kafka'

class Destinations::Kafka
  def initialize(url:, topic:)
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
