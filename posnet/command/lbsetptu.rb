class Posnet::Command::LBSETPTU < Posnet::Command
  escp :checksum => true


  def process_command(*rates)
    rates = rates.slice(0..5)
    "#{rates.size}$p#{rates.map(&:to_s_price).join("/")}/"
  end

end