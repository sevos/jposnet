class Posnet::Command  
  
  def self.calculate_checksum
    @calculate_checksum = true
  end

  def self.not_wrap_in_escp
    @not_wrap_in_escp = true
  end
  
  def initialize(*args)
    @args = args
  end

  def checksum
    byte = 255
    self.process_command(@args).bytes.each { |b| byte = byte ^ b }
    byte.to_s(16).upcase
  end
#TODO
  def to_s
    unless @@not_wrap_in_escp
      if @@calculate_checksum
        
      end
    else
      self.process_command @args
    end
  end
end