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
  instr = s.strip
  weight = 1

  if (s =~ /:/)
    parts = s.split(':').map { |p| p.strip }
    weight = parts[0].to_i
    instr = parts[1]
  end

  if (weight > 1) then
    inst = "#{instr}, weight #{weight}"
  end

  substitutions = {
    'm7b5' => 'Minor 7 flat 5',
    '2nps' => '2 notes per string',

    # Fine for now.
    'r/6/1' => 'sixth string root, first finger',
    'r/6/2' => 'sixth string root, second finger',
    'r/6/3' => 'sixth string root, third finger',
    'r/6/4' => 'sixth string root, fourth finger',
    'r/5/1' => 'fifth string root, first finger',
    'r/5/2' => 'fifth string root, second finger',
    'r/5/3' => 'fifth string root, third finger',
    'r/5/4' => 'fifth string root, fourth finger',
    'r/4/1' => 'fourth string root, first finger',
    'r/4/2' => 'fourth string root, second finger',
    'r/4/3' => 'fourth string root, third finger',
    'r/4/4' => 'fourth string root, fourth finger',
  }

  substitutions.each do |key, val|
    instr.gsub!(key, val)
  end

  return {
    weight: weight,
    instruction: instr
  }
end

instructions = lines.map { |s| extract_weight_and_instruction(s) }
instructions.shuffle!
puts instructions
exit 1

total_weights = instructions.reduce(0) { |c, i| c + i[:weight] }
time_per_weight = (TOTAL_TIME / total_weights).to_i

lines = instructions.map do |i|
  done = [ "Ok", "Good", "Done" ]
  done = done[rand(done.size)]
  pause = [ i[:weight] * time_per_weight, 20 ].max
  [
    "SAY #{i[:instruction]}",
    "PAUSE #{pause}",
    "SAY #{done}!",
    "PAUSE 2"
  ]
end

lines.flatten!
lines.unshift("SAY Starting #{arp_count} arpeggios.")
lines.unshift("PAUSE 3")
lines.push("SAY All done!")
# puts lines.inspect

d = Dictator.new()
d.dictate(lines)
