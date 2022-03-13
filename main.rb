# Read the supplied file.
# Interpret each line as a command and read it.

require_relative './dictator'

f = ARGV[0]
if !File.exist?(f) then
  f = File.join(File.dirname(__FILE__), f)
end
raise "Missing file #{f}" unless File.exist?(f)

lines = File.read(f).
          split("\n").
          map { |s| s.strip }.
          map { |s| s.gsub(/#.*$/, '') }.
          select { |s| s !~ /^$/ }
          
# puts lines

ISTEST = !ENV['TEST'].nil?

d = Dictator.new(ISTEST)
d.dictate(lines)
