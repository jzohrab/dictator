# Dictates each line aloud.
class Dictator
  
  def initialize(istest = false)
    @voice = 'Daniel'  # Default
    @istest = istest
    @nopause = false
    @nocount = false
  end

  def voice(s)
    puts "Switching voice to #{s}"
    @voice = s.strip
  end

  def say(s)
    # puts "Saying #{s}"
    `say -v #{@voice} "#{s}"` unless @istest
  end

  def pause(s)
    return if @istest
    return if @nopause
    # puts "pausing #{s.to_f}"
    sleep(s.to_f)
  end

  def count(s)
    return if @nocount
    parts = s.split(' ')

    startat = parts[0].to_i
    endat = parts[2].to_i
    counters = (startat..endat).to_a
    if (endat < startat) then
      counters = (endat..startat).to_a.reverse
    end

    wait = 1
    if (parts.length == 5)
      wait = parts[4]
    end

    counters.each do |i|
      starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      say(i)
      ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      elapsed = ending - starting
      extra_wait = wait.to_f - elapsed
      # puts "Already elapsed #{elapsed} during the say, so wait another #{extra_wait}"
      if (extra_wait > 0) then
        pause(extra_wait)
      end
    end
  end

  def waitforuser(s)
    prompt = s.strip
    if (prompt == '') then
      prompt = "Hit Return to continue"
    end
    say(prompt)
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
      # puts '-' * 20
      puts lin
      parts = lin.split(' ')
      command = parts.shift
      args = parts.join(' ')
      case command
      when 'NOPAUSE'
        puts "** turning off pauses"
        @nopause = true
      when 'NOCOUNT'
        puts "** turning off counts"
        @nocount = true
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
