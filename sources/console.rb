require 'oj'
require 'readline'

class Sources::Console
  def initialize; end

  def each_message
    while read_string = Readline.readline("> ", true)
      next unless read_string.length > 0
      yield Oj.load(read_string)
    end
  end
end
