class Sources::Base
  attr_reader :log_level

  def initialize(log_level: 'low')
    @log_level = log_level
  end
end
