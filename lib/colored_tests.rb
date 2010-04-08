require 'test/unit/ui/console/testrunner'

module Color
  COLORS = { :clear => 0, :red => 31, :green => 32, :yellow => 33 }
  def self.method_missing(color_name, *args)
    colname = color_name.to_s
    ansi_color = (colname =~ /^light/ ?
                  light_color(colname.gsub(/light/, '')) :
                  color(colname))
    ansi_color + args.first + color(:clear)
  end
  def self.color(color)
    "\e[#{COLORS[color.to_sym]}m" 
  end
  def self.light_color(color)
    "\e[1;#{COLORS[color.to_sym]}m" 
  end
end


class Test::Unit::UI::Console::TestRunner
  def adjust_io_fd
    if !@io_set && PLATFORM =~ /win32/
      @io_set = true
      require 'Win32/Console/ANSI'
      @io = Win32::Console::ANSI::IO.new
    end
  end
  
  def output_single(something, level=NORMAL)
    return unless (output?(level))
    adjust_io_fd
    something = case something
                when '.' then Color.lightgreen('.')
                when 'F' then Color.lightred("F")
                when 'E' then Color.lightyellow("E")
                else something
                end
    @io.write(something)
    @io.flush
  end
end



class Test::Unit::TestResult
  alias :old_to_s :to_s
  def to_s
    if old_to_s =~ /\d+ tests, \d+ assertions, (\d+) failures, (\d+) errors/
      Color.send($1.to_i != 0 || $2.to_i != 0 ? :lightred : :lightgreen, $&)
    end
  end
end

class Test::Unit::TestResult
  alias :old_to_s :to_s
  def to_s
    if old_to_s =~ /\d+ tests, \d+ assertions, (\d+) failures, (\d+) errors/
      Color.send($1.to_i != 0 || $2.to_i != 0 ? :lightred : :lightgreen, $&)
    end
  end
end

class Test::Unit::Failure
  alias :old_long_display :long_display
  def long_display
    old_long_display.sub('Failure', Color.lightred('Failure'))
  end
end

class Test::Unit::Error
  alias :old_long_display :long_display
  def long_display
    old_long_display.sub('Error', Color.lightyellow('Error'))
  end
end