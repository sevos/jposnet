class Posnet::Command::LBSETHDR < Posnet::Command
  escp :checksum => true

  def process_command(header)
    "0$f#{header.to_s}#{255.chr}"
  end
end