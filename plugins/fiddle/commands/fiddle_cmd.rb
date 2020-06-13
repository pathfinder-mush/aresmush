module AresMUSH
  module Fiddle
    class FiddleCmd
      include CommandHandler

      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end

      def handle
        client.emit "Hello, #{enactor.name}! I see you're fiddling with fiddle."
        client.emit_ooc "This is an OOC emit."
        client.emit_success "This is a success message."
        client.emit_failure "This is a failure message."
      end

    end
  end
end
