# Take a guitar practice file, transform it into a dictator file.

require_relative './dictator'

raise "File required" if ARGV[0].nil?

f = ARGV[0]
if !File.exist?(f) then
  f = File.join(File.dirname(__FILE__), f)
end
raise "Missing file #{ARGV[0]}" unless File.exist?(f)

lines = File.read(f).
          split("\n").
          select { |lin| lin !~ /^#/ }.
          select { |lin| lin.strip != "" }

# Total practice time, seconds:
TOTAL_TIME = 30 * 60
time_per_line = (TOTAL_TIME / lines.size).to_i

lines = lines.map do |lin|
  [
    "SAY #{lin}",
    "PAUSE #{time_per_line}",
    "BEEP 5 times"
  ]
end

lines.flatten!
lines.push("SAY All done!")
puts lines.inspect

d = Dictator.new()
d.dictate(lines)
