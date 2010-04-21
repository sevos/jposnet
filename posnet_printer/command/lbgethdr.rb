class Posnet::Command::LBGETHDR < Posnet::Command
  escp :checksum => true

  def process_command
    "#u"
  end

  def process_response(response)
    $1 if response =~ /\eP1#U(.*)..\e\\/
  end
end