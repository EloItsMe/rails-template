# frozen_string_literal: true

module Flash
  class FlashComponent < ViewComponent::Base
    TYPES = %i[notice alert].freeze

    def initialize(type:)
      super
      @type = validate_type(type)
    end

    private

    def validate_type(type)
      raise ArgumentError, "Invalid type: #{type}, valid types are: #{TYPES.join(', ')}" unless TYPES.include?(type)

      type
    end
  end
end
