module Retest
  class Sounds
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
      else
        raise ArgumentError.new("No sounds were found for type: #{sound}.")
      end

      @thread.new { @kernel.system(*args) }
    end
  end
end