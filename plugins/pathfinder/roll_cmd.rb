module AresMUSH
  module Pathfinder
    class RollCmd
      include CommandHandler

      attr_accessor :roll

      def parse_args
        args = cmd.parse_args(ArgParser.arg1_equals_optional_arg2_slash_optional_arg3)
        self.roll = args.arg1.gsub(/\s+/, "")
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
            result3 = Array.new
            result3 += [i]
          end
        end

        total = result1.sum + result2.sum

        if args.arg1? & args.arg2? & !args.arg3
          client.emit("To: #{enactor_name}, #{args.arg2}\n#{enactor_name} rolls: #{roll}\nDie Rolls: #{result1}\nTotal: #{total}")
          for t in args.arg2
            Login.emit_if_logged_in args.arg2, "To: #{enactor_name} #{args.arg2}\n#{enactor_name} rolls: #{roll}\nDie Rolls: #{result1}\nTotal: #{total}"
          end
        elsif args.arg1? & args.arg3? & !args.arg2
          enactor_room.emit("To: #{enactor_name}, #{args.arg2}\n#{enactor_name} rolls: #{roll}\nDie Rolls: #{result1}\nTotal: #{total}\nComment: #{comment}")
        elsif args.arg1? & args.arg2? & args.arg3
          enactor_room.emit("#{enactor_name} rolls: #{roll}\nDie Rolls: #{result1}\nTotal: #{total}\nComment: #{comment}")
          for t in args.arg2
            Login.emit_if_logged_in args.arg2, "To: #{enactor_name} #{args.arg2}\n#{enactor_name} rolls: #{roll}\nDie Rolls: #{result1}\nTotal: #{total}"
          end
        else
          enactor_room.emit("#{enactor_name} rolls: #{roll}\nDie Rolls: #{result1}\nTotal: #{total}")
        end
        client.emit_success("Done!")

      end
    end
  end
end
