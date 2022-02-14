# Read the supplied file.
# Interpret each line as a command and read it.

lines = File.read(ARGV[0]).
          split("\n").
          map { |s| s.strip }.
          map { |s| s.gsub(/#.*$/, '') }.
          select { |s| s !~ /^$/ }
          
# puts lines

ISTEST = !ENV['TEST'].nil?

$voice = 'Daniel'  # Default

def say(s)
  puts "Saying #{s}"
  `say -v #{$voice} "#{s}"` unless ISTEST
end

def pause(s)
  puts "pausing #{s.to_f}"
  sleep(s.to_f) unless ISTEST
end

def count(s)
  parts = s.split(' ')
  i = parts[0].to_i
  while i <= parts[2].to_i
    say(i)
    pause(parts[4])
    i += 1
  end
end

def beep(s)
  parts = s.split(' ')
  count = parts[0].to_i
  wait = 1
  if (parts.length == 4)
    wait = parts[3]
  end
  i = 0
  while i < count
    puts i
    puts `tput bel` unless ISTEST
    pause(wait)
    i += 1
  end
end

lines.each do |lin|
  puts '-' * 20
  puts lin
  parts = lin.split(' ')
  command = parts.shift
  args = parts.join(' ')
  case command
  when 'SAY'
    say(args)
  when 'COUNT'
    count(args)
  when 'PAUSE'
    pause(args)
  when 'BEEP'
    beep(args)
  when 'EXIT'
    puts 'Quitting ...'
    exit(0)
  else
    puts "Unknown command #{command}"
  end
end
