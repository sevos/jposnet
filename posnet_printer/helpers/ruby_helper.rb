def returning(arg, &block)
  yield arg
  return arg
end

class Fixnum
  def on?(position)
    self & 2**position == 2**position
  end

  def off?(position)
    not on?(position)
  end
end

class String
  def to_mazovia
    returning self.dup do |text|
      {
        "ą" => 0x86.chr,
        "ć" => 0x8D.chr,
        "ę" => 0x91.chr,
        "ł" => 0x92.chr,
        "ń" => 0xA4.chr,
        "ó" => 0xA2.chr,
        "ś" => 0x9E.chr,
        "ź" => 0xA6.chr,
        "ż" => 0xA7.chr,
        
        "Ą" => 0x8F.chr,
        "Ć" => 0x95.chr,
        "Ę" => 0x90.chr,
        "Ł" => 0x9C.chr,
        "Ń" => 0xA5.chr,
        "Ó" => 0xA3.chr,
        "Ś" => 0x98.chr,
        "Ź" => 0xA0.chr,
        "Ż" => 0xA1.chr,
      }.each { |orig, replacement| text.gsub!(orig, replacement)}
     end
  end
end