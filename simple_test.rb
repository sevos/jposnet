require 'java'
require 'rxtx/rxtxcomm'

gnu = Java::Gnu

ports = gnu.io.CommPortIdentifier.port_identifiers

ports.each do |port|
  puts port.name
end