require 'kafka'

class Sources::Kafka
  def initialize(url:, topic:)
    @kafka = ::Kafka.new(url)
    @consumer = @kafka.consumer(group_id: "ruby-json-transformer-#{topic}-consumer-#{Time.now.to_i}")
    @consumer.subscribe(topic)
  end

  def each_message
    @consumer.each_message do |message|
      puts message.topic, message.partition, message.offset, message.key, message.value
      yield Oj.load(message.value)
    end
  end
end
