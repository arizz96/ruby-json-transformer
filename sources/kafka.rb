require 'kafka'

require_relative 'base'

class Sources::Kafka < Sources::Base
  def initialize(log_level: 'low', url:, topic:)
    super(log_level: log_level)
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
