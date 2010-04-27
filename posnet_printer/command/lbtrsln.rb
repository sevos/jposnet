class Posnet::Command::LBTRSLN < Posnet::Command
  escp :checksum => true


  def process_command(line_number, name, quantity, price, gross_price)
    @quantity = quantity
    @price = price.to_s_price
    @gross_price = gross_price.to_s_price
    "#{line_number}$l#{name[0,40].to_mazovia}\r#{formatted_quantity}\r /#{@price}/#{@gross_price}/"
  end

  def formatted_quantity
    ("%10f" % @quantity)[0,10]
  end
end