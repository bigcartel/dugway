require 'time'

class Time
  class << self
    # Support Ruby 1.8.7's Time.parse('Today')
    alias :old_parse :parse
    def parse(date, now=self.now)
      date = now.to_s if date =~ /today/i
      old_parse(date, now)
    end
  end
end
