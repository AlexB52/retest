module Retest
  class Output
    def self.force_batch_failures(failed_paths, out: nil)
      return nil if no_failures?(failed_paths)
      
      output = format_failures_message(failed_paths)
      deliver_output(output, out)
    end

    private_class_method def self.no_failures?(failed_paths)
      failed_paths.nil? || failed_paths.empty?
    end

    private_class_method def self.format_failures_message(failed_paths)
      <<~OUTPUT

Retest could not find matching tests for these inputs:
#{format_failed_paths(failed_paths)}

      OUTPUT
    end

    private_class_method def self.format_failed_paths(failed_paths)
      failed_paths.map { |path| "  - #{path}" }.join("\n")
    end

    private_class_method def self.deliver_output(output, out)
      out ? out.write(output) : output
    end
  end
end