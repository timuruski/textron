module Textron
  module Ansi
    # Cursor movement
    CURSOR_UP =      "\e[A"
    CURSOR_DOWN =    "\e[B"
    CURSOR_FORWARD = "\e[C"
    CURSOR_BACK =    "\e[D"
    CURSOR_NEXT =    "\e[E"
    CURSOR_PREV =    "\e[F"
    CURSOR_POS = proc { |n = 1, m = 1| "\e[#{n};#{m}H" }

    RESET =          "\e[0m"
    TEXT_BOLD =      "\e[1m"
    TEXT_FAINT =     "\e[2m"
    TEXT_ITALIC =    "\e[3m"
    TEXT_UNDERLINE = "\e[4m"

    HIDE_CURSOR = "\e[?25l"
    SHOW_CURSOR = "\e[?25h"

    # ESC[38:5:⟨n⟩m Select foreground color
    # ESC[48:5:⟨n⟩m Select background color
    FG = lambda { |n| "\e[38;5;#{n}m" }
    BG = lambda { |n| "\e[48;5;#{n}m" }

    # ESC[ 38;2;⟨r⟩;⟨g⟩;⟨b⟩ m Select RGB foreground color
    # ESC[ 48;2;⟨r⟩;⟨g⟩;⟨b⟩ m Select RGB background color
    FG_RGB = lambda { |r,g,b| "\e[38;2;#{r};#{g};#{b}m" }
    BG_RGB = lambda { |r,g,b| "\e[48;2;#{r};#{g};#{b}m" }

    ERASE_BELOW = "\e[0J"
    ERASE_ABOVE = "\e[1J"
    ERASE_ALL =   "\e[2J"
    ERASE_SAVED = "\e[3J"
    CLEAR_LINE =  "\e[0K"

    # Xterm alternative buffer
    ENABLE_ALT =  "\e[?1049h"
    DISABLE_ALT = "\e[?1049l"

    def self.alt_buffer(&)
      print ENABLE_ALT
      yield if block_given?
    ensure
      print DISABLE_ALT
    end

    def self.rows
      @rows ||= IO.console.winsize[0]
    end

    def self.cols
      @cols ||= IO.console.winsize[1]
    end

    Signal.trap("SIGWINCH") do
      @rows = nil
      @cols = nil
    end
  end
end
