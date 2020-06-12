module AresMUSH
  module Fiddle
    class FiddleCmd
      include CommandHandler

      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      def handle
        client.emit_success "Done!"
      end

    end
  end
end
