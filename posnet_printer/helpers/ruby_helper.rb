def returning(arg, &block)
  a = arg
  yield a
  return a
end