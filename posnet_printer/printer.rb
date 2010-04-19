Dir["posnet_printer/helpers/**/*"].each do |file|
  require file
end
require "rxtx/rxtxcomm"
require "posnet_printer/printer/connection"

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
          @connection = Connection.new port_name
          @initialized = true
          log_message "Port initialized"
        else
          log_message "Port #{port_name} is busy"
        end
      else
        log_message "Incorrect port name"
      end
    end

    def initialized?; @initialized; end

    def execute(command)
      @connection.send command.to_s
      if command.expects_response?
        wait_for_response
        return command.process_response(@connection.read)
      end
    end

    def close
      @connection.close if initialized?
    end
    
    def status
      returning execute(Posnet::Command::DLE.new) do |dle|
        if dle[:online]
          dle.merge!(execute(Posnet::Command::ENQ.new))
        end
      end
    end

    private
    
    def wait_for_response(counter=3)
      if @connection.response_available?
        return true
      else
        if counter > 0
          sleep 0.1
          return wait_for_response(counter-1)
        else
          return false
        end
      end
    end
  end
end