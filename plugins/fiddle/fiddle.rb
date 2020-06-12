$:.unshift File.dirname(__FILE__)

module AresMUSH
  module Fiddle
    def self.plugin_dir
      File.dirname(__FILE__)
    end

    def self.shortcuts
      {}
    end

    def self.get_cmd_handler(client, cmd, enactor)
      if (cmd.root_is?("fiddle"))
        return FiddleCmd
      end

      nil
    end
  end
end
