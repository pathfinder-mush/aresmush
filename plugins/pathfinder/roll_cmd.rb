module AresMUSH
  module Pathfinder
    class RollCmd
      include CommandHandler

      attr_accessor :roll, :target, :comment

      def parse_args
        args = cmd.parse_args(CustomArgParsers.arg1_equals_optional_arg2_slash_optional_arg3)
        roll = args.arg1.gsub(/\s+/, "")

        if !args.arg2.nil?
          target = args.arg2
        end

        if !args.arg3.nil?
          comment = args.arg3
        end

      end



      
    end
  end
end
