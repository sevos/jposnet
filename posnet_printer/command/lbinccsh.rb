class Posnet::Command::LBINCCSH < Posnet::Command
  escp :checksum => true

  def process_command(amount)
    "1#i%.2f/" % amount
  end
end