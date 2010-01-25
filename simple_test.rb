require 'java'
require 'rxtx/rxtxcomm'

gnu = Java::Gnu

def import(klass)
  const_name = klass.to_s.split("::").last.to_sym
  Object.const_set const_name, klass
end

def checksum(command)
  byte = 255
  command.bytes.each { |b| byte = byte ^ b }
  byte.to_s(16).upcase
end

import gnu.io.CommPort
import gnu.io.CommPortIdentifier
import gnu.io.SerialPort

import java.io.FileDescriptor
import java.io.IOException
import java.io.InputStream
import java.io.OutputStream

port_name = "/dev/tty.usbserial"
port_id = CommPortIdentifier.getPortIdentifier(port_name)

unless port_id.currently_owned?
  comm_port = port_id.open self.class.name, 2000
  if comm_port.is_a? SerialPort
    serial_port = comm_port
    serial_port.setSerialPortParams(9600,SerialPort::DATABITS_8,SerialPort::STOPBITS_1,SerialPort::PARITY_NONE);
    in_stream = serial_port.getInputStream()
    out_stream = serial_port.getOutputStream()
    
    3.times do
      out_stream.write 7
      out_stream.flush
    end

    command = "1#l"
    
    command = "\eP#{command}#{checksum(command)}\e\\"
    #command = "\eP#{command}\e\\"
    
    out_stream.write command.to_java_string.bytes
    
    out_stream.flush

    puts command
    puts command.to_java_string.bytes.map{|c| c.to_s(16)}.join(' ')
    
  else
    puts "Only serial ports are supported!"
  end
  comm_port.close
else
  puts "Port #{port_name} is currently used!"
end
