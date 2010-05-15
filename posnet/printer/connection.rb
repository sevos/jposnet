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

      attr_reader :streams
      
      def initialize(port_name)
        if serial_port_names.include? port_name
          @port_id = CommPortIdentifier.getPortIdentifier(port_name)
          @port = @port_id.open DRV_NAME, (PROCESSING_NAP * 1000).to_i
          @streams = {:out => @port.getOutputStream(), :in => @port.getInputStream()}
        else
          raise "Incorrect port name. Allowed port names are: #{serial_port_names.join(', ')}"
        end
      end
    
      def send(string)
        string.bytes.each { |x| @streams[:out].write x }
      end
    
      def read(expect_trailing_escape = false)
        if response_available?
          returning "" do |response|
            response << @streams[:in].read while response_available?
            if expect_trailing_escape
              i = 0
              until (response =~ /^.*\e\\$/ or i > 2) do
                i+=1
                if wait_for_response
                  response << read
                end
              end
            end
          end
        end
      end

      def close
        @streams.values.each(&:close)
        @streams = nil
        @port.close if @port.is_a? SerialPort
      end

      def response_available?
        @streams[:in].available > 0
      end

      def wait_for_response(counter=3)
        if response_available?
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
end