module Retest
  # This library format output messages displayed to the user
  module Output
    module_function

    # This methods format the force batch search failures and prints it to IO if
    # passed in or returns the message otherwise
    def force_batch_failures(paths, out: nil)
      return unless paths&.any?

      output = "\n"
      output += "Retest could not find matching tests for these inputs:\n"
      paths.each do |invalid_path|
        output += "  - #{invalid_path}\n"
      end
      output += "\n"

      if out
        out.puts output
      else
        output
      end
    end
  end
end