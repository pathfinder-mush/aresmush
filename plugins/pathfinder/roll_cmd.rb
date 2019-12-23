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

        result1 = Array.new
        result2 = Array.new
        result3 = Array.new

        for i in items
          if /^[\d]+[d][\d]+$/.match(i)
            die = i.split(/[d]/)
            num = die[0].to_i
            sides = die[1].to_i
            result1 += num.times.collect { |d| rand(sides) + 1 }
          elsif /^-*\d+$/.match(i)
            result2 += [i.to_i]
          else
            result3 += [i]
          end
        end

        total = result1.sum + result2.sum


        enactor_room.emit("#{enactor_name} rolls: #{roll}\nDie Rolls: #{result1}\nTotal: #{total}")


        client.emit_success("Done!")

      end
    end
  end
end
