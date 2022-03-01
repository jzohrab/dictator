# Take a guitar practice file, transform it into a dictator file.

require_relative './dictator'

lines = File.read(ARGV[0]).
          split("\n").
          select { |lin| lin !~ /^#/ }.
          select { |lin| lin.strip != "" }

# Total practice time, seconds:
TOTAL_TIME = 20 * 60

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
