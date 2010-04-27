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
          execute :dle
          sleep 0.5
          if online?
            execute :lbserm, :normal
            log_message "Normal error handling activated"
          end
        else log_message "Port #{port_name} is busy"
        end
      else log_message "Incorrect port name"
      end
    end

    def initialized?; @initialized; end

    def execute(command, *args)
      if command.is_a? Symbol
        command_class = eval("Posnet::Command::#{command.to_s.upcase}")
        command = command_class.new *args
      end

      @connection.send command.to_s
      if command.expects_response?
        if @connection.wait_for_response
          return command.process_response(@connection.read)
        end
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
    
    def error
      unless ready?
        execute :lbernrq
      end
    end

    def ready?
      status = self.status
      status[:online] && status[:feed_ok] && !status[:error] && status[:last_command_success]
    end

    def online?
      self.status[:online]
    end

    # temporary solution for faster commands calling
    def method_missing(name, *args)
      execute name.to_sym, *args
    end

    def cash_status; execute :lbcshsts; end

    def payment(amount)
      execute :lbinccsh, amount
    end

    def payout(amount)
      execute :lbdeccsh, amount
    end

    def set_header(header)
      header.gsub!("\n\r", "\r")
      header.gsub!("\n", "\r")
      execute :lbsethdr, header
    end
  end
end