require "rxtx/rxtxcomm"

import gnu.io.CommPort
import gnu.io.CommPortIdentifier
import gnu.io.SerialPort

module Posnet
  class Printer
    class Connection
      include SerialPortHelper
      DRV_NAME = "Posnet Printer Ruby Driver"
      PROCESSING_NAP = 0.1
      
      logger
      attr_reader :streams
      
      def initialize(port_name)
        if serial_port_names.include? port_name
          @port_id = CommPortIdentifier.getPortIdentifier(port_name)
          @port = @port_id.open DRV_NAME, (PROCESSING_NAP * 1000).to_i
          @streams = {:out => @port.getOutputStream(), :in => @port.getInputStream()}
          log_message "Connection initialized"
        else
          raise "Incorrect port name. Allowed port names are: #{serial_port_names.join(', ')}"
        end
      end
    
      def send(string)
      log_data "Sending data", string
      string.bytes.each { |x| @streams[:out].write x }
      end
    
      def read
        if response_available?
          returning "" do |response|
            response << @streams[:in].read while response_available?
            log_data "Response received", response
          end
        else 
          log_message "No response received"
          return nil
        end
      end

      def close
        @streams.values.each(&:close)
        @streams = nil
        @port.close if @port.is_a? SerialPort
        log_message "Connection closed"
      end

      def response_available?
        @streams[:in].available > 0
      end
    end
  end
end