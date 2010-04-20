class Posnet::Command::LBERNRQ < Posnet::Command

  escp :checksum => false

  def process_command 
    "#n"
  end

  def process_response(response)
    $1.to_i if response =~ /\eP1#E(\d{1,2})\e\\/
  end
end