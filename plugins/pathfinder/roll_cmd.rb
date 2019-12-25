module AresMUSH
  module Pathfinder
    class RollCmd
      include CommandHandler, Custom
      attr_accessor :roll, :roll_target, :roll_comment, :names

     def parse_args
       args = cmd.parse_args(CustomArgParsers.arg1_equals_optional_arg2_slash_optional_arg3)
       self.roll = args.arg1.gsub(/\s+/, "")

       if !args.arg2.nil?
         self.roll_target = args.arg2
         self.names = roll_target.split(/\W+/)
       end

       if !args.arg3.nil?
         self.roll_comment = args.arg3
       end

     end

     def handle

       # The first thing we're going to do is break up the roll into individual
       # pieces. First, we look for any subtraction symbol (-) and replace it
       # with a "+-". Then, we go through and break up the roll into
       # pieces, so that it becomes an array of dice, positive or negative
       # integers, and keywords that we will have to look up. We do that by
       # looking for an addition symbol (+), and telling the game that
       # everything between addition symbols is its own piece. We call each
       # piece an "item", because we aren't sure yet what they are.


       items = roll.gsub("-", "+-").split(/[\+]/)

       # Now we create a place to store the different kinds of pieces. Since
       # the code doesn't know what all is in there, we have to tell it later.
       # Ruby won't let us store things in an object that doesn't exist, so we
       # just create them as empty arrays for now.

       dice_rolls = Array.new
       mods = Array.new
       stats = Array.new

       # Now we are going to look at the items and figure out their type. We
       # do that using some regular expressions, below. You will use them
       # frequently, so it's best to learn what they do.

       # Here, we are just looking for any two sets of numbers separated by the
       # letter 'd'. That will tell us that what we are looking at is a die.
       # While we assume that all dice are additive, we have included support
       # for subtracting dice, because why not? The symbols -* at the beggining
       # of the code tell us to look for zero or more of the previous chars, so
       # it can start with either nothing, or a negative sign. (Do you see now
       # why we replaced the "-" with a "+-"? Because by doing that, we keep
       # the - symbol in the item.)

       dice_regex = /^-*[\d]+[d][\d]+$/

       # Now we want to look for raw integers. It's the same as before, but
       # it just matches any number. The special symbol \d means "match any
       # digit" in regular expressions, and the + symbol means "one or more."
       # This one too starts with the -*, so that negative numbers go in too.
       # Remember, * means "zero or more" of the preceding symbol.

       integer_regex = /^-*\d+$/

       # Now we want to tell the code that for each piece of the roll, we want
       # to see what kind of thing it is, and put it in the appropriate
       # container.

       # We start with the dice. Dice don't do us much good by themselves,
       # so we need to do a little work here. First, we look at each die, and
       # figure out how many there are, and what number of sides it has. If it
       # says "2d4", for example, we know that there are two four-sided dice.
       # So we 'split' the 'die' into the number of dice (num) and the 'sides'.
       # Then we tell the code to pick a random number between 1 and the sides
       # of the die -- essentially, rolling it. We do that a number of 'times'
       # equal to the number of dice, and 'collect' the individual results in
       # an array, 'dice_rolls'. Notice that we split the die into 'num' and
       # 'sides', and then convert 'num' and 'sides' to integers. Commands
       # are strings, and math on strings will give you weird results.

       for i in items
         if dice_regex.match(i)
           die = i.split(/[d]/)
           num = die[0].to_i
           sides = die[1].to_i
           dice_rolls += num.times.collect { |d| rand(1..sides) }
         # Not a die? Is it an integer? Those we can just save by themselves.
         elsif integer_regex.match(i)
           mods += [i.to_i]
         # If it's not an integer, and not a die, then it's a keyword. Easy.
         else
           stats += [i]
         end
       end

       # Now we just add up the die rolls and the modifiers. We don't have a
       # way to look up stat keywords right now, so they'll just sit there by
       # themselves.

       total = dice_rolls.sum + mods.sum

       # Now we tell the game what to do based on what kind of command was
       # entered.

       if !roll.nil? & !roll_target.nil? & roll_comment.nil?
         client.emit("To: #{roll_target}\n#{enactor_name} rolls: #{roll}\nDie Rolls: #{dice_rolls}\nTotal: #{total}")
         for name in names
           Login.emit_if_logged_in Character.find_one_by_name(name), "To: #{roll_target}\n#{enactor_name} rolls: #{roll}\nDie Rolls: #{dice_rolls}\nTotal: #{total}"
         end
         client.emit_success("Done!")
       elsif !roll.nil? & roll_target.nil? & !roll_comment.nil?
         enactor_room.emit("#{enactor_name} rolls: #{roll}\nDie Rolls: #{dice_rolls}\nTotal: #{total}\nroll_comment: #{roll_comment}")
         client.emit_success("Done!")
       elsif !roll.nil? & !roll_target.nil? & !roll_comment.nil?
         client.emit("To: #{roll_target}\n#{enactor_name} rolls: #{roll}\nDie Rolls: #{dice_rolls}\nTotal: #{total}\nroll_comment: #{roll_comment}")
         for name in names
           Login.emit_if_logged_in Character.find_one_by_name(name), "To: #{roll_target}\n#{enactor_name} rolls: #{roll}\nDie Rolls: #{dice_rolls}\nTotal: #{total}\nroll_comment: #{roll_comment}"
         end
         client.emit_success("Done!")
       elsif !roll.nil? & roll_target.nil? & roll_comment.nil?
         enactor_room.emit("#{enactor_name} rolls: #{roll}\nDie Rolls: #{dice_rolls}\nTotal: #{total}")
         client.emit_success("Done!")
       else
         client.emit_failure("I'm not sure how to roll that.")
       end
     end
  end
end
