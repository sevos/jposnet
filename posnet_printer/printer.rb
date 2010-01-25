Dir["posnet_printer/helpers/**/*"].each do |file|
  require file
end
require "rxtx/rxtxcomm"

import gnu.io.CommPort
import gnu.io.CommPortIdentifier
import gnu.io.SerialPort

module Posnet
  class Printer
    include SerialPortHelper
    logger
    DRV_NAME = "Posnet Printer Ruby Driver"

    def initialize(port_name)
      if serial_port_names.include? port_name
        port = CommPortIdentifier.getPortIdentifier(port_name)
        unless port.currently_owned?
          
          log_message "Port initialized"
        else
          log_message "Port #{port_name} is busy"
        end
      else
        log_message "Incorrect port name"
      end
    end

    def initialized?; @initialized; end



  end
end