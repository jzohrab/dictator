# Take a guitar practice file, transform it into a dictator file.

require_relative './dictator'

# Total practice time, seconds:
TOTAL_TIME = 25 * 60

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
arp_count = lines.size

def extract_weight_and_instruction(s)
  s.gsub!(/#.*/, '')  # remove comments
  h = {
    weight: 1,
    instruction: s.strip
  }
  if (s =~ /:/)
    parts = s.split(':').map { |p| p.strip }
    h[:weight] = parts[0].to_i
    h[:instruction] = parts[1]
  end

  if (h[:weight] > 1) then
    h[:instruction] = "Weight #{h[:weight]}, #{h[:instruction]}"
  end

  return h
end

instructions = lines.map { |s| extract_weight_and_instruction(s) }
puts instructions
# exit 1

total_weights = instructions.reduce(0) { |c, i| c + i[:weight] }
time_per_weight = (TOTAL_TIME / total_weights).to_i

lines = instructions.map do |i|
  pause = [ i[:weight] * time_per_weight, 20 ].max
  [
    "SAY #{i[:instruction]}",
    "PAUSE #{pause}"
  ]
end

lines.flatten!
lines.unshift("SAY Starting #{arp_count} arpeggios.")
lines.unshift("PAUSE 3")
lines.push("SAY All done!")
# puts lines.inspect

d = Dictator.new()
d.dictate(lines)
