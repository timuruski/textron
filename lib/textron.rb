require "zeitwerk"
require "io/console"

module Textron
  Loader = Zeitwerk::Loader.for_gem.tap do |loader|
    loader.setup
  end
end
