# frozen_string_literal: true

module Flash
  class FlashComponent < ViewComponent::Base
    def initialize(type:)
      super
      @type = type
    end
  end
end
