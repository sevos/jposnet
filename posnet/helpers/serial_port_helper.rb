module SerialPortHelper
  def serial_port_names
    gnu.io.CommPortIdentifier.port_identifiers.map(&:name)
  end
end