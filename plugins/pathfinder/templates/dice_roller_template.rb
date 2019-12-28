module AresMUSH
  module Pathfinder
    class DiceRollerTemplate < ErbTemplateRenderer

      attr_accessor :roll, :roll_target, :dice_rolls, :total, :roll_comment

      def initialize(roll, roll_target, dice_rolls, total, roll_comment)
        @roll = roll
        @roll_target = roll_target
        @dice_rolls = dice_rolls
        @total = total
        @roll_comment = roll_comment

        super File.dirname(__FILE__) + "/roll.erb"
      end

    end
  end
end
