class Posnet::Command::LBTRSHDR < Posnet::Command
  escp :checksum => true

  def process_command(lines)
    "0$h"
  end
end