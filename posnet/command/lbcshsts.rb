class Posnet::Command::LBCSHSTS < Posnet::Command
  escp :checksum => true

  def process_command
    "1#t"
  end
end