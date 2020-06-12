module AresMUSH
  module Fiddle
    class FiddleCmd
      include CommandHandler

      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      def handle
        client.emit_success "This is a test just to make sure that fiddle really truly works."
      end

    end
  end
end
