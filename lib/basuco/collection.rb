module Basuco
  class Collection < Array
    def to_s
      self.inject("") { |m,i| "#{m}#{i.to_s}\n"}
    end
  end
end