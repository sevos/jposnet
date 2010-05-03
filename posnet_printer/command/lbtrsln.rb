class Posnet::Command::LBTRSLN < Posnet::Command
  escp :checksum => true


  def process_command(line_number, name, quantity, price, ptu = " ")
    @quantity = quantity
    @price = price.to_s_price
    @gross_price = (quantity*price).to_s_price
    @ptu = ptu.to_s.upcase[0,1]
    "#{line_number}$l#{name[0,40].to_mazovia}\r#{formatted_quantity}\r#{@ptu}/#{@price}/#{@gross_price}/"
  end

  def formatted_quantity
    ("%10f" % @quantity)[0,10]
  end
end