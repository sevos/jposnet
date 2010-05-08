class Posnet::Command::LBTRSHDR < Posnet::Command
  escp :checksum => true

  def process_command
    "0$h"
  end
end