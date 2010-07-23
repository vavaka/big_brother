class Handler
  def initialize (bot, from)
    @bot = bot
    @from = from
    puts "initialize next new handler for #{@from}"
  end

  def handle (text)
    puts "handle message #{text} from #{@from}"
    case text
    when /да ну/u
      message = %{ну да}
    when /сгенери исключение "([^"]+)"/u
      raise($1)
    when /запусти.*?таймер.*?/u
      if @timer
        message = %{таймер уже запущен}
      else
        if text =~ /(\d+)/
          period = $1.to_i
        else
          period = 30
        end
        Thread.new do
          Timer.every period do
            @bot.message @from, "таймер стработал!"
          end
        end
        message = %{запустил с периодом #{period}}
      end
    end
    message ||= "не понял."
    say message
  end

  def say (message)
    puts "next handler say #{message} for #{@from}"
    @bot.message @from, message
  end
end