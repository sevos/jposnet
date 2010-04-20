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