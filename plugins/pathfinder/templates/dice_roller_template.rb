module AresMUSH
  module Pathfinder
    class DiceRollTemplate < ErbTemplateRenderer

      def initialize
        super File.dirname(__FILE__) + "/roll.erb"
      end
      
    end
  end
end
