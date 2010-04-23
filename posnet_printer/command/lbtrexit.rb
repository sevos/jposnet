class Posnet::Command::LBTREXIT < Posnet::Command
  escp :checksum => true


  def process_command(total_price, payment = 0.0)
    @total_price = total_price
    @payment = payment
    "1;0$e000\r#{formatted_payment}/#{formatted_total_price}/"
  end

  def formatted_total_price(price=@total_price)
    "%.2f" % price
  end

  def formatted_payment
    formatted_total_price @payment
  end
end