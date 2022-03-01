# Read the supplied file.
# Interpret each line as a command and read it.

require_relative './dictator'

lines = File.read(ARGV[0]).
          split("\n").
          map { |s| s.strip }.
          map { |s| s.gsub(/#.*$/, '') }.
          select { |s| s !~ /^$/ }
          
# puts lines

ISTEST = !ENV['TEST'].nil?

d = Dictator.new(ISTEST)
d.dictate(lines)
