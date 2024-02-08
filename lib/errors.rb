module Errors
  class MissingTagError < StandardError
    def message
      "Creative or Placement tag is missing."
    end
  end
end