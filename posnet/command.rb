class Posnet::Command
  def self.escp(options={})
    define_method :to_s do
      if options[:checksum]
        puts "Sending: #{generate}"
        puts "Checksum: #{checksum}"
        "\eP#{generate}#{checksum}\e\\"
      else
        "\eP#{generate}\e\\"
      end
    end
  end

  def self.on_response_wait_for_trailing_escape
    define_method(:on_response_wait_for_trailing_escape) { true }
  end

  def initialize(*args)
    @args = args
  end

  def checksum
    byte = 255
    generate.bytes.each { |b| byte = byte ^ b }
    returning byte.to_s(16).upcase do |str|
      str.insert(0, "0") if byte < 16
    end
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

  def on_response_wait_for_trailing_escape
    false
  end
end

Dir["posnet/command/**/*"].each do |file|
  require file
end