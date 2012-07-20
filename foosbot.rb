# encoding: utf-8
require 'cinch'
require 'cleverbot'

bot = Cinch::Bot.new do
  configure do |c|
    c.server = "irc.jlatt.com"
    c.port = 9999
    c.nick = 'foosbot'
    c.password = 'foosball'
    c.ssl = true
    #c.channels = ["#foosbot-test3"]
    #c.channels = ["#verticalbrands foosball", "#foosbot-test"]
    c.channels = ["#verticalbrands", "#foosbot-test"]

    @game = false
    @players = []
    @blacklist = ['foosbot', 'matt', 'matt_', 'Kyle', 'Kyle_', 'ChrisH']
    @sicklist = []
    @brolist = []
    @cleverbot = Cleverbot::Client.new

    @cool_names = 
      ["Slab Bulkhead",
       "Fridge Largemeat",
       "Punt Speedchunk",
       "Butch Deadlift",
       "Bold Bigflank",
       "Splint Chesthair",
       "Flint Ironstag",
       "Bolt Vanderhuge",
       "Thick McRunfast",
       "Blast Hardcheese",
       "Buff Drinklots",
       "Trunk Slamchest",
       "Fist Rockbone",
       "Stump Beefgnaw",
       "Smash Lampjaw",
       "Punch Rockgroin",
       "Buck Plankchest",
       "Stump Chunkman",
       "Dirk Hardpeck",
       "Rip Steakface",
       "Slate Slabrock",
       "Crud Bonemeal",
       "Brick Hardmeat",
       "Rip Sidecheek",
       "Punch Sideiron",
       "Gristle McThornBody",
       "Slake Fistcrunch",
       "Buff Hardback",
       "Bob Johnson",
       "Blast Thickneck",
       "Crunch Buttsteak",
       "Slab Squatthrust",
       "Lump Beefrock",
       "Touch Rustrod",
       "Reef Blastbody",
       "Big McLargeHuge",
       "Smoke Manmuscle",
       "Beat Punchbeef",
       "Pack Blowfist",
       "Roll Fizzlebeef"]
  end

  on :join do |m|
    greetings = ['bam a lam', 'cocaine is a hell of a gem', '...', 'these pringles are making me thirsty'].shuffle
    m.reply greetings.first if m.user.nick == bot.nick
  end

  on :message, "!foos" do |m|
    if @sicklist.include? m.user.nick
      m.reply "#{m.user.nick}: Sorry no sick players allowed."
      return nil
    end

    if @brolist.include? m.user.nick
      m.reply "#{m.user.nick}: Nah, you're too bro'd out brah."
      return nil
    end


    if not @game
      #if Random.new.rand(0..6) == 0
      #  m.reply "I'm sorry Dave, I'm afriad I can't do that." if Random.new.rand(0..3) == 0
      #  return nil
      #end

      name = @cool_names[Random.new.rand(0..@cool_names.size-1)]

      m.reply "#{m.user.nick} aka #{name} wants to start a game, who's in? Type !foos to join."
      players = m.channel.users.keys.map(&:nick) - @blacklist
      m.reply "#{players.join(', ')} ^"

      @game = true

      if m.user.nick == 'akbk'
        if @players.count < 3
          @players << 'Andy' << 'Ben' if @players.count < 3
        else
          @players << 'Ben||Andy' if @players.count == 3
        end
      else
        @players << m.user.nick
      end
    else
      m.reply "#{m.user.nick} joined the game."

      if m.user.nick == 'akbk'
        if @players.count < 3
          @players << 'Andy' << 'Ben' if @players.count < 3
        else
          @players << 'Ben||Andy' if @players.count == 3
        end
      else
        @players << m.user.nick
      end

      if @players.count < 4
        m.reply "#{4 - @players.count} players still needed.  Current players: #{@players.join(', ')}"
      else
        m.reply "game ready: #{@players.join(', ')}"
        @players = []
        @game = false
        case Random.new.rand(0..7)
        when 0 then m.reply "kthxbai"
        when 1 then m.reply "Hiyooooo!"
        when 2 then m.reply "I'm a personality prototype, you can tell can't you?"
        when 3 then m.reply "Life? Don't talk to me about life."
        when 4 then m.reply "I'd make a suggestion, but you wouldn't listen.  No one ever does."
        when 5 then m.reply "I've calculated your chance of survival, but i don't think you'll like it."
        when 6 then m.reply "This will all end in tears."
        when 7 then m.reply "jenkins-bot: die in a fire"
        end
      end
    end
  end

  on :message, "!cancel" do |m|
    if @game
      @game = false
      @players = []
      m.reply "game cancelled."
    else
      m.reply "no game started."
    end
  end

  on :message, "!status" do |m|
    if @game
      m.reply "#{4 - @players.count} players still needed.  Current players: #{@players.join(', ')}"
    else
      m.reply "no game started."
    end
  end

  on :message, "!help" do |m|
    m.reply "!foos - start or join a game\n!status - check status of current game\n!cancel - cancel current game\n!flip - desk flip\n!help - helpception"
  end

  on :message, /\ rod/ do |m|
    m.reply "That's what she said lol" if Random.new.rand(0..2) == 0
  end

  on :message, /nope/ do |m|
    m.reply "chuck testa" if Random.new.rand(0..3) == 0
  end

  on :message, /banana/ do |m|
    case Random.new.rand(0..6)
    when 0 then m.reply "Hiyooooo!"
    when 1 then m.reply "stfu"
    else m.reply "Hilarious!"
    end
  end

  on :message, /confused/ do |m|
    m.reply "#{m.user.nick}, con-foos-ed?" if Random.new.rand(0..3) == 0
  end

  on :message, /pizza/ do |m|
    m.reply "#{m.user.nick}, are you a vegetarian?" if Random.new.rand(0..1) == 0
  end

  on :message, /jitterbit/ do |m|
    m.reply "*snap* *snap*" if Random.new(0..1) == 0
  end

  on :message, /foosbot/ do |m|
    params = m.reply @cleverbot.write m.message
  end

  on :message, /nyan/ do |m|
    m.reply "-_-_-_-_-_-_-_,------,
_-_-_-_-_-_-_-|   /\\_/\\
-_-_-_-_-_-_-~|__( ^ .^)
_-_-_-_-_-_-_-\"\"  \"\"      "
  end

  on :message, "!flip" do |m|
    m.reply "（╯°□°）╯︵ ┻━┻"
  end

  on :message, "!unflip" do |m|
    m.reply "┬─┬ ﻿ノ( ゜-゜ノ)"
  end

  on :message, "!sup" do |m|
    m.reply "¯\_(ツ)_/¯"
  end

  on :message, /desk\ flip|deskflip|flip\ a\ desk/ do |m|
    m.reply "（╯°□°）╯︵ ┻━┻"
  end
end

bot.start
