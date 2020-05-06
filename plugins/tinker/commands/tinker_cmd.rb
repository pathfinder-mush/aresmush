module AresMUSH
  module Tinker
    class TinkerCmd
      include CommandHandler
      
      def check_can_manage
        return t('dispatcher.not_allowed') if !enactor.has_permission?("tinker")
        return nil
      end
      
      def handle
        args = cmd.parse_args(ArgParser.arg1_equals_arg2)
        num_piggies = integer_arg(args.arg1)
        names = list_arg(args.arg2)
        
        if (num_piggies < names.count)
            client.emit "You have too many names! Give me #{names.count} piggies and I'll name them all."
        elsif (num_piggies > names.count)
            client.emit "You didn't name all the piggies! I need #{num_piggies} names."
        else
            client.emit "You have #{num_piggies} and their names are #{names.join(', ')}."
        end
      end

    end
  end
end
