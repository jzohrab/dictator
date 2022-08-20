# Read the supplied file.
# Interpret each line as a command and read it.

require_relative './dictator'
require 'erb'

f = ARGV[0]
if !File.exist?(f) then
  f = File.join(File.dirname(__FILE__), f)
end
raise "Missing file #{f}" unless File.exist?(f)

renderer = ERB.new(File.read(f))
output = renderer.result()

lines = output.
          split("\n").
          map { |s| s.split(";") }.
          flatten
lines = lines.
          map { |s| s.gsub(/#.*$/, '') }.
          select { |s| s.strip != '' }
          
# puts lines

ISTEST = !ENV['TEST'].nil?

d = Dictator.new(ISTEST)
d.dictate(lines)
