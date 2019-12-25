module AresMUSH
  module Custom
    class CustomArgParsers

    def self.arg1_equals_optional_arg2_slash_optional_arg3
      /(?<arg1>[^\(=|\/)]+)\=?(?<arg2>[^\/]+)?\/?(?<arg3>.+)?/
    end

  end
end
