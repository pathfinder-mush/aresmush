module AresMUSH
  module Pathfinder
    class RollCmd
      include CommandHandler

      attr_accessor :roll

      def parse_args
        self.roll = trim_arg(cmd.args)
      end

      def handle

        items = roll.gsub("-", "+-").split(/[\+]/)

        for i in items
          if /^[\d]+[d][\d]+$/.match(i)
            die = i.split(/[d]/)
            num = die[0]
            sides = die[1]
            result1 += self.num.times.collect { |d| rand(self.sides) + 1 }
          elsif /[0-9]+/.match(i)
            result2 += i
          else
            result3 += result3[i]
          end
        end

        total = result1 + result2

        if defined?(result3)
          client.emit_failure("I don't know how to roll #{result3}")
        else
          enactor_room.emit("#{enactor_name} rolls: #{roll}\nResult: #{total}")
        end

        client.emit_success("Done!")

      end
    end
  end
end
