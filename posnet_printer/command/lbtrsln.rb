class Posnet::Command::LBTRSLN < Posnet::Command
  escp :checksum => true


  def process_command(line_number, name, quantity, price, gross_price)
    @quantity = quantity
    @price = price
    @gross_price = gross_price
    "#{line_number}$l#{name[0,40]}\r#{formatted_quantity}\r /#{formatted_price}/#{formatted_gross_price}/"
  end

  def formatted_quantity
    ("%10f" % @quantity)[0,10]
  end

  def formatted_price(price=@price)
    "%.2f" % price
  end

  def formatted_gross_price
    formatted_price @gross_price
  end
end