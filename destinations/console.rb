require_relative 'base'

class Destinations::Console < Destinations::Base
  def write_message(message)
    puts message.to_s
  end
end
