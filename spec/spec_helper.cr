require "../lib/*"

require "spectator"

Spectator.configure do |config|
  config.randomize  # Randomize test order.
  config.profile    # Display slowest tests.
end
