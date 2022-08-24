# frozen_string_literal: true

class Device
  def initialize
    @recordings = []
  end

  def record(recording)
    @recordings << recording
  end

  def listen
    return unless block_given?

    record(yield)
  end

  def play
    puts recordings.last unless recordings.empty?
  end

  private

  attr_reader :recordings
end

listener = Device.new
listener.play
listener.listen { 'Hello World!' }
listener.listen
listener.play # Outputs "Hello World!"
