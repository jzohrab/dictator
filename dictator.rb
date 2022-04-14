# Dictates each line aloud.
class Dictator
  
  def initialize(istest = false)
    @voice = 'Daniel'  # Default
    @istest = istest
  end

  def voice(s)
    puts "Switching voice to #{s}"
    @voice = s.strip
  end

  def say(s)
    puts "Saying #{s}"
    `say -v #{@voice} "#{s}"` unless @istest
  end

  def pause(s)
    puts "pausing #{s.to_f}"
    sleep(s.to_f) unless @istest
  end

  def count(s)
    parts = s.split(' ')
    i = parts[0].to_i
    wait = 1
    if (parts.length == 5)
      wait = parts[4]
    end

    while i <= parts[2].to_i
      say(i)
      pause(wait)
      i += 1
    end
  end

  def waitforuser(s)
    prompt = s
    if (prompt == '') then
      prompt = "Hit Return to continue"
    end
    say(s)
    $stdin.flush
    $stdin.gets()
    puts "ok ..."
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
      puts `tput bel` unless @istest
      pause(wait)
      i += 1
    end
  end

  # Main method.
  def dictate(lines)
    lines.each do |lin|
      puts '-' * 20
      puts lin
      parts = lin.split(' ')
      command = parts.shift
      args = parts.join(' ')
      case command
      when 'VOICE'
        voice(args)
      when 'SAY'
        say(args)
      when 'COUNT'
        count(args)
      when 'PAUSE'
        pause(args)
      when 'BEEP'
        beep(args)
      when 'WAITFORUSER'
        waitforuser(args)
      when 'EXIT'
        puts 'Quitting ...'
        return
      else
        puts "Unknown command #{command}"
      end
    end
  end

end
