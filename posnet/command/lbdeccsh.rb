class Posnet::Command::LBDECCSH < Posnet::Command
  escp :checksum => true

  def process_command(amount)
    "1#d#{amount.to_s_price}/"
  end
end