require 'lib/timer.rb'
require "lib/handler"
require 'rubygems'
require 'easy-gtalk-bot'
#require 'date'
@handlers = {}

class Module
  def flush(klass)
    remove_const(klass.name.intern)
  end
end

bot = GTalk::Bot.new(:email => "super.nachalnike@gmail.com", :password => 'secret')
bot.get_online
  
bot.on_invitation do |inviter|
  puts "I have been invited by #{inviter}. Yay!"

  # do something useful

  bot.accept_invitation(inviter)
  bot.message(inviter, "Hello there! Thanks for invitation!")
end

bot.on_message do |from, text|
  puts "I got message from #{from}: '#{text}'"
  @handlers[from] = FirstHandler.new bot, from if !@handlers.has_key?(from)
  @handlers[from].handle(text)
end

class FirstHandler
  def initialize (bot, from)
    @bot = bot
    @from = from
    puts "initialize first new handler for #{@from}"
    @next_handler = Handler.new(bot, from)
  end
  
  def handle (text)
    puts "handle message #{text} from #{@from}"
    case text
    when /привет/u
      message = %{привет #{@from}!}
    when /\bиди\b/u
      message = %{сам туда иди}
    when /пригласи ([^ ]+)/u
      bot.invite $1
      message = %{пригласил "#{$1}"}
    when /перезагрузись/u
      Object.flush(Handler)
      load "lib/handler.rb"
      @next_handler = Handler.new(@bot, @from)
      message = %{перезагрузился}
    else
      return @next_handler.handle(text)
    end
    message ||= "не понял."
    # do something useful
    puts "first handler response #{message} for #{@from}"
    @bot.message @from, message
  rescue Exception => ex
    @bot.message @from, "возникло исключение #{ex}"
    puts ex
  end
end