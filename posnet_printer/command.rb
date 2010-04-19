class Posnet::Command
  def self.escp(options={})
    define_method :to_s do
      if options[:checksum]
        "\eP#{generate}#{checksum}\e\\"
      else
        "\eP#{generate}\e\\"
      end
    end
  end

  def initialize(*args)
    @args = args
  end

  def checksum
    byte = 255
    generate.bytes.each { |b| byte = byte ^ b }
    byte.to_s(16).upcase
  end

  def to_s
    generate
  end

  def expects_response?
    self.respond_to? :process_response
  end

  private
  
  def generate
    self.process_command *@args
  end
end

Dir["posnet_printer/command/**/*"].each do |file|
  require file
end