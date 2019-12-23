module AresMUSH
  module Pathfinder
    class RollCmd
      include CommandHandler

      attr_accessor :roll

      def parse_args
        self.roll = cmd.args.gsub(/\s+/, "")
      end

      def handle

        items = roll.gsub("-", "+-").split(/[\+]/)

        for i in items
          if /^[\d]+[d][\d]+$/.match(i)
            self.die = i.split(/[d]/)
            self.num = die[0]
            self.sides = die[1]
            self.result1 += self.num.times.collect { |d| rand(self.sides) + 1 }
          elsif /[0-9]+/.match(i)
            self.result2 += i
          else
            self.result3 += result3[i]
          end
        end

        self.total = result1 + result2

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
