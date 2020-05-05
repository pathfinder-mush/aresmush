module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end
      
      def handle
        if (cmd.args == "0")
            client.emit_ooc "No little piggies."
        elsif (cmd.args == "1")
            client.emit_ooc "One little piggy!" 
        else
            client.emit_ooc "#{cmd.args} little piggies!"
        end
      end

    end
  end
end
