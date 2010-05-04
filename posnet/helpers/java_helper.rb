require "java"

def gnu
  return Java::Gnu
end

def import(klass)
  const_name = klass.to_s.split("::").last.to_sym
  Object.const_set const_name, klass
end