class Posnet::Command::LBINCCSH < Posnet::Command
  escp :checksum => true

  def process_command(amount, options = {})
    till_id = options[:till][0,8] if options[:till]
    teller  = options[:teller][0,17] if options[:teller]

    returning "1#i%.2f/" % amount do |cmd|
      cmd << "#{till_id}\n" if till_id
      cmd << "#{teller}\n" if teller
      puts cmd
    end
  end
end