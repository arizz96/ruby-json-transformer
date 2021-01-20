require 'kafka'

class Sources::Kafka
  def initialize(url:, topic:)
    @kafka = ::Kafka.new(url)
    @consumer = @kafka.consumer(group_id: "ruby-json-transformer-#{topic}-consumer")
    @consumer.subscribe(topic)
  end

  def each_message
    @consumer.each_message do |message|
      yield Oj.load(message.value)
    end
  end
end
