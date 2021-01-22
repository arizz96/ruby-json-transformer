require 'oj'
require 'readline'

require_relative 'base'

class Sources::Console < Sources::Base
  def each_message
    while read_string = Readline.readline("> ", true)
      next unless read_string.length > 0
      yield Oj.load(read_string)
    end
  end
end
