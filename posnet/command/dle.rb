class Posnet::Command::DLE < Posnet::Command
  def process_command 
    "\020"
  end

  def process_response(response)
     return { :online => false } if response.nil?
     byte = response.bytes.first
     return {
       :online => (byte.on?(2)), #ONL
       :feed_ok => (byte.off?(1)), #PE/AKK
       :error => (byte.on?(0)) #ERR
     }     
  end
end