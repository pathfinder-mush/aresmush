module AresMUSH
  module Pathfinder
    class DiceRollerTemplate < ErbTemplateRenderer

      attr_accessor :dice, :roll_target, :dice_rolls, :total, :comment

      def initialize(dice, roll_target, dice_rolls, total, comment)
        super File.dirname(__FILE__) + "/roll.erb"
      end

    end
  end
end
