class Posnet::Command::ENQ < Posnet::Command
  def process_command 
    "\005"
  end

  def process_response(response)
     return Hash.new if response.nil?
     byte = response.bytes.first
     return {
       :trainee_mode => (byte.off?(3)), #FSK
       :last_command_success => (byte.on?(2)), #CMD
       :transaction_mode => (byte.on?(1)), #PAR
       :last_transaction_success => (byte.on?(0)) #TRF
     }     
  end
end