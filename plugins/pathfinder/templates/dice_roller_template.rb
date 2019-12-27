module AresMUSH
  module Pathfinder
    class DiceRollerTemplate < ErbTemplateRenderer

      attr_accessor :roll, :roll_target, :dice_rolls, :total, :comment

      def initialize(self.roll, self.roll_target, self.dice_rolls, self.total, self.comment)
        super File.dirname(__FILE__) + "/roll.erb"
      end

    end
  end
end
