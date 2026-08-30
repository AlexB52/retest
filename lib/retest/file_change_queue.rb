module Retest
  class FileChangeQueue
    def self.collapse(input)
      latest_file = latest(input)
      return input unless latest_file

      "file changed: #{latest_file}"
    end

    def self.latest(input)
      input
        .to_s
        .each_line
        .map { |line| /^file changed:\s(.*)$/.match(line.chomp)&.[](1) }
        .compact
        .last
    end
  end
end
