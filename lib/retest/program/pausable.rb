module Pausable
  def initialize_pause(value = false)
    @paused = value
  end

  def pause
    @paused = true
  end

  def paused?
    @paused
  end

  def resume
    @paused = false
  end

  def running_state
    @paused
  end
end