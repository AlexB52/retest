module ForcedSelection
  attr_reader :selected_test_files

  def initialize_forced_selection(value = [])
    @selected_test_files = value
  end

  def forced_selection?
    !@selected_test_files.empty?
  end

  def reset_selection
    @selected_test_files = []
  end

  def force_selection(test_files)
    @selected_test_files = Array(test_files)
  end
end