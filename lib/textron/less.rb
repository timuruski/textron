module Textron
  class Less
    CURSOR_MIN = 0
    CURSOR_MAX = 1_000

    def initialize
      @cursor = 0
      @file_path = ARGV.first
    end

    def run
      Ansi.alt_buffer do
        File.open(@file_path, "r") do |file|
          loop do
            # print Ansi::ERASE_ALL
            print Ansi::CURSOR_POS[1, 1]

            read_lines(file)
            @max_cursor = @cursor if file.eof?

            key = STDIN.getch
            case key
            when "q"
              break
            when "j"
              cursor_down
            when "k"
              cursor_up
            when "d"
              cursor_down(Ansi.rows / 2)
            when "u"
              cursor_up(Ansi.rows / 2)
            end
          end
        end
      end
    end

    private def read_lines(file, &)
      if file.lineno > @cursor
        file.rewind
        @cursor.times do
          file.readline
        end
      end

      Ansi.rows.times do |n|
        unless file.eof?
          line = file.readline(chomp: true).slice(0, Ansi.cols - 1)
          line = format("%3d %s", @cursor + n + 1, line)
        end

        print Ansi::CURSOR_POS[n + 1]
        print line
        print Ansi::CLEAR_LINE
      end
    end

    def cursor_up(n = 1)
      if @cursor > 0
        @cursor -= n
      end
    end

    def cursor_down(n = 1)
      if @max_cursor.nil? || @cursor < @max_cursor
        @cursor += n
      end
    end
  end
end
