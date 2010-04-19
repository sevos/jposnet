class Posnet::Command::LBFEED < Posnet::Command
  escp :checksum => true
  
  def process_command(lines)
    "#{[1,[20,lines.to_i].min].max}#l"
  end
end