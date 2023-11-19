module Retest
  module Sounds
    module_function

    def for(options)
      options.notify? ? MacOS.new : Mute.new
    end

    class Mute
      def play(_)
      end
      alias update play
    end

    class MacOS
      def initialize(kernel: Kernel, thread: Thread)
        @kernel = kernel
        @thread = thread
      end

      def play(sound)
        args = case sound
        when :tests_fail
          ['afplay', '/System/Library/Sounds/Sosumi.aiff']
        when :tests_pass
          ['afplay', '/System/Library/Sounds/Funk.aiff']
        when :start
          ['afplay', '/System/Library/Sounds/Blow.aiff']
        when :question
          ['afplay', '/System/Library/Sounds/Glass.aiff']
        else
          raise ArgumentError.new("No sounds were found for type: #{sound}.")
        end

        @thread.new { @kernel.system(*args) }
      end
      alias update play
    end
  end
end

# List of Mac Audio Files:
# afplay /System/Library/Sounds/Basso.aiff
# afplay /System/Library/Sounds/Bottle.aiff
# afplay /System/Library/Sounds/Hero.aiff
# afplay /System/Library/Sounds/Ping.aiff
# afplay /System/Library/Sounds/Purr.aiff
# afplay /System/Library/Sounds/Submarine.aiff
# afplay /System/Library/Sounds/Frog.aiff
# afplay /System/Library/Sounds/Morse.aiff
# afplay /System/Library/Sounds/Pop.aiff
# afplay /System/Library/Sounds/Tink.aiff

# USED

# fail:     afplay /System/Library/Sounds/Sosumi.aiff
# pass:     afplay /System/Library/Sounds/Funk.aiff
# start:    afplay /System/Library/Sounds/Blow.aiff
# question: afplay /System/Library/Sounds/Glass.aiff