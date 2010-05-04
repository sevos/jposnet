class Posnet::Command::LBSERM < Posnet::Command
  escp :checksum => true

  MODES = {
    :debug => 0,
    :normal => 1,
    :break_autosend => 2,
    :continue_autosend => 3
  }

  def process_command(mode)
    mode = :debug unless MODES.include?(mode)
    "#{MODES[mode]}#e"
  end
end