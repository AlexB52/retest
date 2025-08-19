module Retest
  class Output
    def self.force_batch_failures(failed_paths, out: nil)
      return nil if failed_paths.nil? || failed_paths.empty?
      
      output = <<~OUTPUT

Retest could not find matching tests for these inputs:
#{failed_paths.map { |path| "  - #{path}" }.join("\n")}

      OUTPUT
      
      if out
        out.write(output)
      else
        output
      end
    end
  end
end